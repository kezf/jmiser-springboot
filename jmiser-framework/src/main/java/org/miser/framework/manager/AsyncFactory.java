package org.miser.framework.manager;

import eu.bitwalker.useragentutils.UserAgent;
import org.miser.common.constant.Constants;
import org.miser.common.utils.AddressUtils;
import org.miser.common.utils.ServletUtils;
import org.miser.common.utils.spring.SpringUtils;
import org.miser.framework.shiro.session.OnlineSession;
import org.miser.framework.util.LogUtils;
import org.miser.framework.util.ShiroUtils;
import org.miser.system.domain.SysLoginInfo;
import org.miser.system.domain.SysOperLog;
import org.miser.system.domain.SysUserOnline;
import org.miser.system.service.ISysOperLogService;
import org.miser.system.service.ISysUserOnlineService;
import org.miser.system.service.impl.SysLoginInfoServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.TimerTask;

/**
 * 异步工厂（产生任务用）
 *
 * @author liuhulu
 */
public class AsyncFactory {
    private static final Logger sys_user_logger = LoggerFactory.getLogger("sys-user");

    /**
     * 同步session到数据库
     *
     * @param session 在线用户会话
     * @return 任务task
     */
    public static TimerTask syncSessionToDb(final OnlineSession session) {
        return new TimerTask() {
            @Override
            public void run() {
                SysUserOnline online = new SysUserOnline();
                online.setSessionId(String.valueOf(session.getId()));
                online.setDeptName(session.getDeptName());
                online.setLoginName(session.getLoginName());
                online.setStartTimestamp(session.getStartTimestamp());
                online.setLastAccessTime(session.getLastAccessTime());
                online.setExpireTime(session.getTimeout());
                online.setLoginIP(session.getHost());
                online.setLoginLocation(AddressUtils.getRealAddressByIP(session.getHost()));
                online.setBrowser(session.getBrowser());
                online.setOs(session.getOs());
                online.setStatus(session.getStatus());
                SpringUtils.getBean(ISysUserOnlineService.class).saveOnline(online);

            }
        };
    }

    /**
     * 操作日志记录
     *
     * @param operLog 操作日志信息
     * @return 任务task
     */
    public static TimerTask recordOper(final SysOperLog operLog) {
        return new TimerTask() {
            @Override
            public void run() {
                // 远程查询操作地点
                operLog.setOperLocation(AddressUtils.getRealAddressByIP(operLog.getOperIP()));
                SpringUtils.getBean(ISysOperLogService.class).insertOperlog(operLog);
            }
        };
    }

    /**
     * 记录登陆信息
     *
     * @param username 用户名
     * @param status   状态
     * @param message  消息
     * @param args     列表
     * @return 任务task
     */
    public static TimerTask recordLoginInfo(final String username, final String status, final String message, final Object... args) {
        final UserAgent userAgent = UserAgent.parseUserAgentString(ServletUtils.getRequest().getHeader("User-Agent"));
        final String ip = ShiroUtils.getIP();
        return new TimerTask() {
            @Override
            public void run() {
                String str = LogUtils.getBlock(ip) + AddressUtils.getRealAddressByIP(ip) + LogUtils.getBlock(username) + LogUtils.getBlock(status) + LogUtils.getBlock(message);
                // 打印信息到日志
                sys_user_logger.info(str, args);
                // 获取客户端操作系统
                String os = userAgent.getOperatingSystem().getName();
                // 获取客户端浏览器
                String browser = userAgent.getBrowser().getName();
                // 封装对象
                SysLoginInfo loginInfo = new SysLoginInfo();
                loginInfo.setLoginName(username);
                loginInfo.setLoginIP(ip);
                loginInfo.setLoginLocation(AddressUtils.getRealAddressByIP(ip));
                loginInfo.setBrowser(browser);
                loginInfo.setOs(os);
                loginInfo.setMsg(message);
                // 日志状态
                if (Constants.LOGIN_SUCCESS.equals(status) || Constants.LOGOUT.equals(status)) {
                    loginInfo.setStatus(Constants.SUCCESS);
                } else if (Constants.LOGIN_FAIL.equals(status)) {
                    loginInfo.setStatus(Constants.FAIL);
                }
                // 插入数据
                SpringUtils.getBean(SysLoginInfoServiceImpl.class).insertLoginInfo(loginInfo);
            }
        };
    }
}
