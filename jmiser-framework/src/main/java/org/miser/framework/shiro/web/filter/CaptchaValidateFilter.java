package org.miser.framework.shiro.web.filter;

import com.google.code.kaptcha.Constants;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.miser.common.constant.ShiroConstants;
import org.miser.common.utils.StringUtils;
import org.miser.framework.util.ShiroUtils;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * 验证码过滤器
 *
 * @author Barry
 */
public class CaptchaValidateFilter extends AccessControlFilter {
    /**
     * 是否开启验证码
     */
    private boolean captchaEnabled = true;

    /**
     * 验证码类型
     */
    private String captchaType = "math";

    public void setCaptchaEnabled(boolean captchaEnabled) {
        this.captchaEnabled = captchaEnabled;
    }

    public void setCaptchaType(String captchaType) {
        this.captchaType = captchaType;
    }

    @Override
    public boolean onPreHandle(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
        request.setAttribute(ShiroConstants.CURRENT_ENABLED, captchaEnabled);
        request.setAttribute(ShiroConstants.CURRENT_TYPE, captchaType);
        return super.onPreHandle(request, response, mappedValue);
    }

    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue)
            throws Exception {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        // 验证码禁用 或不是表单提交 允许访问
        if (captchaEnabled == false || !"post".equals(httpServletRequest.getMethod().toLowerCase())) {
            return true;
        }
        return validateResponse(httpServletRequest, httpServletRequest.getParameter(ShiroConstants.CURRENT_VALIDATECODE));
    }

    public boolean validateResponse(HttpServletRequest request, String validateCode) {
        Object obj = ShiroUtils.getSession().getAttribute(Constants.KAPTCHA_SESSION_KEY);
        String code = String.valueOf(obj != null ? obj : "");
        return !StringUtils.isEmpty(validateCode) && validateCode.equalsIgnoreCase(code);
    }

    @Override
    protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
        request.setAttribute(ShiroConstants.CURRENT_CAPTCHA, ShiroConstants.CAPTCHA_ERROR);
        return true;
    }
}
