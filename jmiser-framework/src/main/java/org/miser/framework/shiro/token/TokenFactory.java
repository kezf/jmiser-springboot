package org.miser.framework.shiro.token;

import org.apache.shiro.authc.AuthenticationToken;

public interface TokenFactory {

    AuthenticationToken createToken(String token);

    String createToken(String username, String password);
}
