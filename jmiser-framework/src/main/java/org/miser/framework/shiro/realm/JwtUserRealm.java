package org.miser.framework.shiro.realm;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.miser.common.constant.Constants;
import org.miser.common.exception.user.UserNotExistsException;
import org.miser.common.utils.MessageUtils;
import org.miser.framework.manager.AsyncFactory;
import org.miser.framework.manager.AsyncManager;
import org.miser.framework.shiro.token.JwtToken;
import org.miser.framework.util.JwtUtils;
import org.miser.framework.util.ShiroUtils;
import org.miser.system.domain.SysUser;
import org.miser.system.service.ISysMenuService;
import org.miser.system.service.ISysRoleService;
import org.miser.system.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashSet;
import java.util.Set;

/**
 * jwt用户登录权限
 *
 * @author Barry
 **/
public class JwtUserRealm extends AuthorizingRealm {
    @Autowired
    private ISysMenuService menuService;

    @Autowired
    private ISysRoleService roleService;

    @Autowired
    private ISysUserService userService;

    @Override
    public boolean supports(AuthenticationToken token) {
        //表示此Realm只支持JwtToken类型
        return token instanceof JwtToken;
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        SysUser user = ShiroUtils.getSysUser();
        // 角色列表
        Set<String> roles = new HashSet<String>();
        // 功能列表
        Set<String> menus = new HashSet<String>();
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        roles = roleService.selectRoleKeys(user.getUserId());
        menus = menuService.selectPermsByUserId(user.getUserId());
        // 角色加入AuthorizationInfo认证对象
        info.setRoles(roles);
        // 权限加入AuthorizationInfo认证对象
        info.setStringPermissions(menus);
        return info;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        String token = (String) authenticationToken.getCredentials();
        String username = JwtUtils.getUsername(token);
        // 查询用户信息
        SysUser user = userService.selectUserByLoginName(username);
        if (user == null) {
            AsyncManager.me().execute(AsyncFactory.recordLoginInfo(username, Constants.LOGIN_FAIL, MessageUtils.message("user.not.exists")));
            throw new UserNotExistsException();
        }
        if (!JwtUtils.verify(token, username, user.getPassword())) {
            AsyncManager.me().execute(AsyncFactory.recordLoginInfo(username, Constants.LOGIN_FAIL, MessageUtils.message("user.unauthorized")));
            throw new UnauthorizedException();
        }
        SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(user, token, getName());
        return info;
    }
}
