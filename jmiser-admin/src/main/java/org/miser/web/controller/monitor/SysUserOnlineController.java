package org.miser.web.controller.monitor;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.miser.common.annotation.Log;
import org.miser.common.core.controller.BaseController;
import org.miser.common.core.domain.AjaxResult;
import org.miser.common.core.page.TableDataInfo;
import org.miser.common.enums.Action;
import org.miser.common.enums.OnlineStatus;
import org.miser.framework.shiro.session.OnlineSession;
import org.miser.framework.shiro.session.OnlineSessionDAO;
import org.miser.framework.util.ShiroUtils;
import org.miser.system.domain.SysUserOnline;
import org.miser.system.service.ISysUserOnlineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 在线用户监控
 *
 * @author Barry
 */
@Controller
@RequestMapping("/monitor/online")
public class SysUserOnlineController extends BaseController {
    private String prefix = "monitor/online";

    @Autowired
    private ISysUserOnlineService userOnlineService;

    @Autowired
    private OnlineSessionDAO onlineSessionDAO;

    @RequiresPermissions("monitor:online:view")
    @GetMapping()
    public String online() {
        return prefix + "/online";
    }

    @RequiresPermissions("monitor:online:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(SysUserOnline userOnline) {
        startPage();
        List<SysUserOnline> list = userOnlineService.selectUserOnlineList(userOnline);
        return getDataTable(list);
    }

    @RequiresPermissions("monitor:online:batchForceLogout")
    @Log(title = "在线用户", action = Action.FORCE)
    @PostMapping("/batchForceLogout")
    @ResponseBody
    public AjaxResult batchForceLogout(@RequestParam("ids[]") String[] ids) {
        for (String sessionId : ids) {
            SysUserOnline online = userOnlineService.selectOnlineById(sessionId);
            if (online == null) {
                return error("用户已下线");
            }
            OnlineSession onlineSession = (OnlineSession) onlineSessionDAO.readSession(online.getSessionId());
            if (onlineSession == null) {
                return error("用户已下线");
            }
            if (sessionId.equals(ShiroUtils.getSessionId())) {
                return error("当前登陆用户无法强退");
            }
            onlineSession.setStatus(OnlineStatus.off_line);
            onlineSessionDAO.update(onlineSession);
            online.setStatus(OnlineStatus.off_line);
            userOnlineService.saveOnline(online);
        }
        return success();
    }

    @RequiresPermissions("monitor:online:forceLogout")
    @Log(title = "在线用户", action = Action.FORCE)
    @PostMapping("/forceLogout")
    @ResponseBody
    public AjaxResult forceLogout(String sessionId) {
        SysUserOnline online = userOnlineService.selectOnlineById(sessionId);
        if (sessionId.equals(ShiroUtils.getSessionId())) {
            return error("当前登陆用户无法强退");
        }
        if (online == null) {
            return error("用户已下线");
        }
        OnlineSession onlineSession = (OnlineSession) onlineSessionDAO.readSession(online.getSessionId());
        if (onlineSession == null) {
            return error("用户已下线");
        }
        onlineSession.setStatus(OnlineStatus.off_line);
        onlineSessionDAO.update(onlineSession);
        online.setStatus(OnlineStatus.off_line);
        userOnlineService.saveOnline(online);
        return success();
    }
}
