package org.miser.web.controller.monitor;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.miser.common.annotation.Log;
import org.miser.common.core.controller.BaseController;
import org.miser.common.core.domain.AjaxResult;
import org.miser.common.core.page.TableDataInfo;
import org.miser.common.enums.Action;
import org.miser.common.utils.poi.ExcelUtil;
import org.miser.system.domain.SysLoginInfo;
import org.miser.system.service.ISysLoginInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 系统访问记录
 *
 * @author Barry
 */
@Controller
@RequestMapping("/monitor/logininfo")
public class SysLoginInfoController extends BaseController {
    private String prefix = "monitor/logininfo";

    @Autowired
    private ISysLoginInfoService loginInfoService;

    @RequiresPermissions("monitor:logininfo:view")
    @GetMapping()
    public String loginInfo() {
        return prefix + "/logininfo";
    }

    @RequiresPermissions("monitor:logininfo:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(SysLoginInfo loginInfo) {
        startPage();
        List<SysLoginInfo> list = loginInfoService.selectLoginInfoList(loginInfo);
        return getDataTable(list);
    }

    @Log(title = "登陆日志", action = Action.EXPORT)
    @RequiresPermissions("monitor:logininfo:export")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(SysLoginInfo loginInfo) {
        List<SysLoginInfo> list = loginInfoService.selectLoginInfoList(loginInfo);
        ExcelUtil<SysLoginInfo> util = new ExcelUtil<SysLoginInfo>(SysLoginInfo.class);
        return util.exportExcel(list, "登陆日志");
    }

    @RequiresPermissions("monitor:logininfo:remove")
    @Log(title = "登陆日志", action = Action.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids) {
        return toAjax(loginInfoService.deleteLoginInfoByIds(ids));
    }

    @RequiresPermissions("monitor:logininfo:remove")
    @Log(title = "登陆日志", action = Action.CLEAN)
    @PostMapping("/clean")
    @ResponseBody
    public AjaxResult clean() {
        loginInfoService.cleanLoginInfo();
        return success();
    }
}
