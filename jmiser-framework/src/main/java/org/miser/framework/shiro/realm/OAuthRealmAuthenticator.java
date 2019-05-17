package org.miser.framework.shiro.realm;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.pam.AtLeastOneSuccessfulStrategy;
import org.apache.shiro.authc.pam.ModularRealmAuthenticator;
import org.apache.shiro.realm.Realm;

import java.util.ArrayList;
import java.util.Collection;

public class OAuthRealmAuthenticator extends ModularRealmAuthenticator {
    @Override
    protected AuthenticationInfo doAuthenticate(AuthenticationToken authenticationToken)
            throws AuthenticationException {
        assertRealmsConfigured();
        Collection<Realm> realms = getRealms();
        Collection<Realm> authRealms = new ArrayList<>();
        for (Realm realm : realms) {
            if (realm.supports(authenticationToken)) {
                authRealms.add(realm);
            }
        }

        AtLeastOneSuccessfulStrategy authenticationStrategy = new AtLeastOneSuccessfulStrategy();
        this.setAuthenticationStrategy(authenticationStrategy);

        if (authRealms.size() == 1) {
            return doSingleRealmAuthentication(authRealms.iterator().next(), authenticationToken);
        } else {
            return doMultiRealmAuthentication(authRealms, authenticationToken);
        }
    }

}
