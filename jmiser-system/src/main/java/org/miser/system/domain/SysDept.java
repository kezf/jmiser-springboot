package org.miser.system.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.miser.common.core.domain.BaseEntity;

/**
 * 部门表 sys_dept
 *
 * @author Barry
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class SysDept extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /**
     * 部门ID
     */
    private Long deptId;

    /**
     * 父部门ID
     */
    private Long parentId;

    /**
     * 祖级列表
     */
    private String ancestors;

    /**
     * 部门名称
     */
    private String deptName;

    /**
     * 显示顺序
     */
    private String orderNum;

    /**
     * 负责人
     */
    private String leader;

    /**
     * 联系电话
     */
    private String phone;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 部门状态:0正常,1停用
     */
    private Integer status;

    /**
     * 删除标志（0代表存在 2代表删除）
     */
    private Integer delFlag;

    /**
     * 父部门名称
     */
    private String parentName;

}
