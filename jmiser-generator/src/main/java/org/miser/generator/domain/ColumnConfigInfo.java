package org.miser.generator.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

/**
 * 字段类型配置 由数据库字段的注释解析而来
 * 注释结构示例:{"title": "状态", "type": "dict", "value": "sys_common_status"} {"title": "登录时间", "type": "date"}
 *
 * @author Barry
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class ColumnConfigInfo {
    /**
     * 属性标题
     */
    private String title;

    /**
     * 属性类型 dict(字典，value对应字典管理的字典类型), date(包括date)
     */
    private String type;

    /**
     * 属性值，参考数据类型，可为空
     */
    private String value;

}
