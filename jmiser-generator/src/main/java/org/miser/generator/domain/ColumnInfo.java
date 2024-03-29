package org.miser.generator.domain;

import lombok.Data;
import org.miser.common.json.JSON;
import org.miser.common.utils.StringUtils;

/**
 * ry数据库表列信息
 *
 * @author Barry
 */
@Data
public class ColumnInfo {
    /**
     * 字段名称
     */
    private String columnName;

    /**
     * 字段类型
     */
    private String dataType;

    /**
     * 列描述
     */
    private String columnComment;

    /**
     * 列配置
     */
    private ColumnConfigInfo configInfo;

    /**
     * Java属性类型
     */
    private String attrType;

    /**
     * Java属性名称(第一个字母大写)，如：user_name => UserName
     */
    private String attrName;

    /**
     * Java属性名称(第一个字母小写)，如：user_name => userName
     */
    private String sAttrName;

    /**
     * 执行计划（包含了与索引相关的一些细节信息）
     */
    private String extra;

    public void setColumnComment(String columnComment) throws Exception {
        // 根据列描述解析列的配置信息
        if (StringUtils.isNotEmpty(columnComment) && columnComment.startsWith("{")) {
            this.configInfo = JSON.unmarshal(columnComment, ColumnConfigInfo.class);
            this.columnComment = configInfo.getTitle();
        } else {
            this.columnComment = columnComment;
        }
    }

}
