package org.miser.common.annotation;

import org.miser.common.enums.Access;
import org.miser.common.enums.Action;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 自定义操作日志记录注解
 *
 * @author Barry
 */
@Target({ElementType.PARAMETER, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface Log {
    /**
     * 模块
     */
    String title() default "";

    /**
     * 业务功能
     */
    Action action() default Action.OTHER;

    /**
     * 访问类别
     */
    Access access() default Access.MANAGE;

    /**
     * 是否保存请求的参数
     */
    boolean isSaveRequestData() default true;
}
