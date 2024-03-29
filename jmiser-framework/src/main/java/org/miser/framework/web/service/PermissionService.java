package org.miser.framework.web.service;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

/**
 * js调用 thymeleaf 实现按钮权限可见性
 *
 * @author Barry
 */
@Service("permission")
public class PermissionService {
    public String hasPermi(String permission) {
        return isPermittedOperator(permission) ? "" : "hidden";
    }

    public String hasRole(String role) {
        return hasRoleOperator(role) ? "" : "hidden";
    }

    /**
     * 判断用户是否拥有某个权限
     *
     * @param permission 权限字符串
     * @return 结果
     */
    private boolean isPermittedOperator(String permission) {
        return SecurityUtils.getSubject().isPermitted(permission);
    }

    /**
     * 判断用户是否拥有某个角色
     *
     * @param role 角色字符串
     * @return 结果
     */
    private boolean hasRoleOperator(String role) {
        return SecurityUtils.getSubject().hasRole(role);
    }

}
