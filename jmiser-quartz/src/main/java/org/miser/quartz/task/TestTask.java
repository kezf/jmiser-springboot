package org.miser.quartz.task;

import org.springframework.stereotype.Component;

/**
 * 定时任务调度测试
 *
 * @author Barry
 */
@Component("testTask")
public class TestTask {
    public void testParams(String params) {
        System.out.println("执行有参方法：" + params);
    }

    public void testNoParams() {
        System.out.println("执行无参方法");
    }
}
