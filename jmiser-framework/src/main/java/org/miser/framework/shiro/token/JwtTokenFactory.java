package org.miser.framework.shiro.token;

import lombok.Data;
import org.apache.shiro.authc.AuthenticationToken;
import org.miser.framework.util.JwtUtils;

@Data
public class JwtTokenFactory implements TokenFactory {

    private String algorithm;

    private long expireTime;

    public JwtTokenFactory() {
    }

    @Override
    public AuthenticationToken createToken(String token) {
        return new JwtToken(token);
    }

    @Override
    public String createToken(String username, String password) {
        return JwtUtils.sign(username, password, getExpireTime());
    }
}
