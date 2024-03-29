-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
CREATE TABLE QRTZ_JOB_DETAILS
(
    sched_name        varchar(120) NOT NULL,
    job_name          varchar(200) NOT NULL,
    job_group         varchar(200) NOT NULL,
    description       varchar(250) NULL,
    job_class_name    varchar(250) NOT NULL,
    is_durable        varchar(1)   NOT NULL,
    is_nonconcurrent  varchar(1)   NOT NULL,
    is_update_data    varchar(1)   NOT NULL,
    requests_recovery varchar(1)   NOT NULL,
    job_data          blob         NULL,
    PRIMARY KEY (sched_name, job_name, job_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
CREATE TABLE QRTZ_TRIGGERS
(
    sched_name     varchar(120) NOT NULL,
    trigger_name   varchar(200) NOT NULL,
    trigger_group  varchar(200) NOT NULL,
    job_name       varchar(200) NOT NULL,
    job_group      varchar(200) NOT NULL,
    description    varchar(250) NULL,
    next_fire_time bigint(13)   NULL,
    prev_fire_time bigint(13)   NULL,
    priority       integer      NULL,
    trigger_state  varchar(16)  NOT NULL,
    trigger_type   varchar(8)   NOT NULL,
    start_time     bigint(13)   NOT NULL,
    end_time       bigint(13)   NULL,
    calendar_name  varchar(200) NULL,
    misfire_instr  smallint(2)  NULL,
    job_data       blob         NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, job_name, job_group) REFERENCES QRTZ_JOB_DETAILS (sched_name, job_name, job_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
CREATE TABLE QRTZ_SIMPLE_TRIGGERS
(
    sched_name      varchar(120) NOT NULL,
    trigger_name    varchar(200) NOT NULL,
    trigger_group   varchar(200) NOT NULL,
    repeat_count    bigint(7)    NOT NULL,
    repeat_interval bigint(12)   NOT NULL,
    times_triggered bigint(10)   NOT NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
CREATE TABLE QRTZ_CRON_TRIGGERS
(
    sched_name      varchar(120) NOT NULL,
    trigger_name    varchar(200) NOT NULL,
    trigger_group   varchar(200) NOT NULL,
    cron_expression varchar(200) NOT NULL,
    time_zone_id    varchar(80),
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
CREATE TABLE QRTZ_BLOB_TRIGGERS
(
    sched_name    varchar(120) NOT NULL,
    trigger_name  varchar(200) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    blob_data     blob         NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_CALENDARS;
CREATE TABLE QRTZ_CALENDARS
(
    sched_name    varchar(120) NOT NULL,
    calendar_name varchar(200) NOT NULL,
    calendar      blob         NOT NULL,
    PRIMARY KEY (sched_name, calendar_name)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS
(
    sched_name    varchar(120) NOT NULL,
    trigger_group varchar(200) NOT NULL,
    PRIMARY KEY (sched_name, trigger_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
CREATE TABLE QRTZ_FIRED_TRIGGERS
(
    sched_name        varchar(120) NOT NULL,
    entry_id          varchar(95)  NOT NULL,
    trigger_name      varchar(200) NOT NULL,
    trigger_group     varchar(200) NOT NULL,
    instance_name     varchar(200) NOT NULL,
    fired_time        bigint(13)   NOT NULL,
    sched_time        bigint(13)   NOT NULL,
    priority          integer      NOT NULL,
    state             varchar(16)  NOT NULL,
    job_name          varchar(200) NULL,
    job_group         varchar(200) NULL,
    is_nonconcurrent  varchar(1)   NULL,
    requests_recovery varchar(1)   NULL,
    PRIMARY KEY (sched_name, entry_id)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
CREATE TABLE QRTZ_SCHEDULER_STATE
(
    sched_name        varchar(120) NOT NULL,
    instance_name     varchar(200) NOT NULL,
    last_checkin_time bigint(13)   NOT NULL,
    checkin_interval  bigint(13)   NOT NULL,
    PRIMARY KEY (sched_name, instance_name)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ----------------------------
DROP TABLE IF EXISTS QRTZ_LOCKS;
CREATE TABLE QRTZ_LOCKS
(
    sched_name varchar(120) NOT NULL,
    lock_name  varchar(40)  NOT NULL,
    PRIMARY KEY (sched_name, lock_name)
) ENGINE = innodb DEFAULT CHARSET = utf8;

DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
CREATE TABLE QRTZ_SIMPROP_TRIGGERS
(
    sched_name    varchar(120)   NOT NULL,
    trigger_name  varchar(200)   NOT NULL,
    trigger_group varchar(200)   NOT NULL,
    str_prop_1    varchar(512)   NULL,
    str_prop_2    varchar(512)   NULL,
    str_prop_3    varchar(512)   NULL,
    int_prop_1    int            NULL,
    int_prop_2    int            NULL,
    long_prop_1   bigint         NULL,
    long_prop_2   bigint         NULL,
    dec_prop_1    numeric(13, 4) NULL,
    dec_prop_2    numeric(13, 4) NULL,
    bool_prop_1   varchar(1)     NULL,
    bool_prop_2   varchar(1)     NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS (sched_name, trigger_name, trigger_group)
) ENGINE = innodb DEFAULT CHARSET = utf8;

-- ----------------------------
-- 1、部门表
-- ----------------------------
DROP TABLE IF EXISTS sys_dept;
CREATE TABLE sys_dept
(
    dept_id     int(11) NOT NULL AUTO_INCREMENT COMMENT '部门ID',
    parent_id   int(11)     DEFAULT 0 COMMENT '父部门ID',
    ancestors   varchar(50) DEFAULT '' COMMENT '祖级列表',
    dept_name   varchar(30) DEFAULT '' COMMENT '部门名称',
    order_num   int(4)      DEFAULT 0 COMMENT '显示顺序',
    leader      varchar(20) DEFAULT NULL COMMENT '负责人',
    phone       varchar(11) DEFAULT NULL COMMENT '联系电话',
    email       varchar(50) DEFAULT NULL COMMENT '邮箱',
    status      char(1)     DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
    del_flag    char(1)     DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    create_by   varchar(64) DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64) DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    PRIMARY KEY (dept_id)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '部门表';

-- ----------------------------
-- 2、用户信息表
-- ----------------------------
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user
(
    user_id     int(11)     NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    dept_id     int(11)      DEFAULT NULL COMMENT '部门ID',
    login_name  varchar(30) NOT NULL COMMENT '登录账号',
    user_name   varchar(30) NOT NULL COMMENT '用户昵称',
    user_type   varchar(2)   DEFAULT '00' COMMENT '用户类型（00系统用户）',
    email       varchar(50)  DEFAULT '' COMMENT '用户邮箱',
    phone       varchar(11)  DEFAULT '' COMMENT '手机号码',
    sex         char(1)      DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
    avatar      varchar(100) DEFAULT '' COMMENT '头像路径',
    password    varchar(50)  DEFAULT '' COMMENT '密码',
    salt        varchar(20)  DEFAULT '' COMMENT '盐加密',
    status      char(1)      DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
    del_flag    char(1)      DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    login_ip    varchar(20)  DEFAULT '' COMMENT '最后登陆IP',
    login_date  datetime COMMENT '最后登陆时间',
    create_by   varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    remark      varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (user_id)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '用户信息表';

-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
DROP TABLE IF EXISTS sys_post;
CREATE TABLE sys_post
(
    post_id     int(11)     NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
    post_code   varchar(64) NOT NULL COMMENT '岗位编码',
    post_name   varchar(50) NOT NULL COMMENT '岗位名称',
    post_sort   int(4)      NOT NULL COMMENT '显示顺序',
    status      char(1)      DEFAULT '0' COMMENT '状态（0正常 1停用）',
    create_by   varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    remark      varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (post_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '岗位信息表';

-- ----------------------------
-- 4、角色信息表
-- ----------------------------
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role
(
    role_id     int(11)      NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    role_name   varchar(30)  NOT NULL COMMENT '角色名称',
    role_key    varchar(100) NOT NULL COMMENT '角色权限字符串',
    role_sort   int(4)       NOT NULL COMMENT '显示顺序',
    data_scope  char(1)      DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限）',
    status      char(1)      NOT NULL COMMENT '角色状态（0正常 1停用）',
    del_flag    char(1)      DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    create_by   varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    remark      varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (role_id)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '角色信息表';

-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu
(
    menu_id     int(11)     NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
    menu_name   varchar(50) NOT NULL COMMENT '菜单名称',
    parent_id   int(11)      DEFAULT 0 COMMENT '父菜单ID',
    order_num   int(4)       DEFAULT 0 COMMENT '显示顺序',
    url         varchar(200) DEFAULT '#' COMMENT '请求地址',
    menu_type   char(1)      DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
    visible     char(1)      DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
    perms       varchar(100) DEFAULT NULL COMMENT '权限标识',
    icon        varchar(100) DEFAULT '#' COMMENT '菜单图标',
    create_by   varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    remark      varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (menu_id)
) ENGINE = innodb AUTO_INCREMENT = 2000 DEFAULT CHARSET = utf8 COMMENT = '菜单权限表';

-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role
(
    user_id int(11) NOT NULL COMMENT '用户ID',
    role_id int(11) NOT NULL COMMENT '角色ID',
    PRIMARY KEY (user_id, role_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '用户和角色关联表';

-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu
(
    role_id int(11) NOT NULL COMMENT '角色ID',
    menu_id int(11) NOT NULL COMMENT '菜单ID',
    PRIMARY KEY (role_id, menu_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '角色和菜单关联表';

-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
DROP TABLE IF EXISTS sys_role_dept;
CREATE TABLE sys_role_dept
(
    role_id int(11) NOT NULL COMMENT '角色ID',
    dept_id int(11) NOT NULL COMMENT '部门ID',
    PRIMARY KEY (role_id, dept_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '角色和部门关联表';

-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
DROP TABLE IF EXISTS sys_user_post;
CREATE TABLE sys_user_post
(
    user_id int(11) NOT NULL COMMENT '用户ID',
    post_id int(11) NOT NULL COMMENT '岗位ID',
    PRIMARY KEY (user_id, post_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '用户与岗位关联表';

-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
DROP TABLE IF EXISTS sys_oper_log;
CREATE TABLE sys_oper_log
(
    oper_id       int(11) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
    title         varchar(50)   DEFAULT '' COMMENT '模块标题',
    action        tinyint(2)    DEFAULT 0 COMMENT '业务功能',
    method        varchar(100)  DEFAULT '' COMMENT '方法名称',
    access        tinyint(1)    DEFAULT 0 COMMENT '访问类型（0其它 1后台用户 2手机端用户）',
    oper_name     varchar(50)   DEFAULT '' COMMENT '操作人员',
    dept_name     varchar(50)   DEFAULT '' COMMENT '部门名称',
    oper_url      varchar(255)  DEFAULT '' COMMENT '请求URL',
    oper_ip       varchar(30)   DEFAULT '' COMMENT '主机地址',
    oper_location varchar(255)  DEFAULT '' COMMENT '操作地点',
    oper_param    varchar(2000) DEFAULT '' COMMENT '请求参数',
    status        char(1)       DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
    error_msg     varchar(2000) DEFAULT '' COMMENT '错误消息',
    oper_time     datetime COMMENT '操作时间',
    PRIMARY KEY (oper_id)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '操作日志记录';

-- ----------------------------
-- 11、字典类型表
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_type;
CREATE TABLE sys_dict_type
(
    dict_id     int(11) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
    dict_name   varchar(100) DEFAULT '' COMMENT '字典名称',
    dict_type   varchar(100) DEFAULT '' COMMENT '字典类型',
    status      char(1)      DEFAULT '0' COMMENT '状态（0正常 1停用）',
    create_by   varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    remark      varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (dict_id),
    UNIQUE (dict_type)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '字典类型表';

-- ----------------------------
-- 12、字典数据表
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_data;
CREATE TABLE sys_dict_data
(
    dict_code   int(11) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
    dict_sort   int(4)       DEFAULT 0 COMMENT '字典排序',
    dict_label  varchar(100) DEFAULT '' COMMENT '字典标签',
    dict_value  varchar(100) DEFAULT '' COMMENT '字典键值',
    dict_type   varchar(100) DEFAULT '' COMMENT '字典类型',
    css_class   varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
    list_class  varchar(100) DEFAULT NULL COMMENT '表格回显样式',
    is_default  char(1)      DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
    status      char(1)      DEFAULT '0' COMMENT '状态（0正常 1停用）',
    create_by   varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time datetime COMMENT '创建时间',
    update_by   varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time datetime COMMENT '更新时间',
    remark      varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (dict_code)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '字典数据表';

-- ----------------------------
-- 13、参数配置表
-- ----------------------------
DROP TABLE IF EXISTS sys_config;
CREATE TABLE sys_config
(
    config_id    int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
    config_name  varchar(100) DEFAULT '' COMMENT '参数名称',
    config_key   varchar(100) DEFAULT '' COMMENT '参数键名',
    config_value varchar(100) DEFAULT '' COMMENT '参数键值',
    config_type  char(1)      DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
    create_by    varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time  datetime COMMENT '创建时间',
    update_by    varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time  datetime COMMENT '更新时间',
    remark       varchar(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (config_id)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '参数配置表';

-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
DROP TABLE IF EXISTS sys_login_info;
CREATE TABLE sys_login_info
(
    info_id        int(11) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
    login_name     varchar(50)  DEFAULT '' COMMENT '登录账号',
    login_ip       varchar(50)  DEFAULT '' COMMENT '登录IP地址',
    login_location varchar(255) DEFAULT '' COMMENT '登录地点',
    browser        varchar(50)  DEFAULT '' COMMENT '浏览器类型',
    os             varchar(50)  DEFAULT '' COMMENT '操作系统',
    status         char(1)      DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
    msg            varchar(255) DEFAULT '' COMMENT '提示消息',
    login_time     datetime COMMENT '访问时间',
    PRIMARY KEY (info_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '系统访问记录';

-- ----------------------------
-- 15、在线用户记录
-- ----------------------------
DROP TABLE IF EXISTS sys_user_online;
CREATE TABLE sys_user_online
(
    sessionId        varchar(50)  DEFAULT '' COMMENT '用户会话id',
    login_name       varchar(50)  DEFAULT '' COMMENT '登录账号',
    dept_name        varchar(50)  DEFAULT '' COMMENT '部门名称',
    login_ip          varchar(50)  DEFAULT '' COMMENT '登录IP地址',
    login_location   varchar(255) DEFAULT '' COMMENT '登录地点',
    browser          varchar(50)  DEFAULT '' COMMENT '浏览器类型',
    os               varchar(50)  DEFAULT '' COMMENT '操作系统',
    status           varchar(10)  DEFAULT '' COMMENT '在线状态on_line在线off_line离线',
    start_timestamp  datetime COMMENT 'session创建时间',
    last_access_time datetime COMMENT 'session最后访问时间',
    expire_time      int(5)       DEFAULT 0 COMMENT '超时时间，单位为分钟',
    PRIMARY KEY (sessionId)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '在线用户记录';

-- ----------------------------
-- 16、定时任务调度表
-- ----------------------------
DROP TABLE IF EXISTS sys_job;
CREATE TABLE sys_job
(
    job_id          int(11) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
    job_name        varchar(64)  DEFAULT '' COMMENT '任务名称',
    job_group       varchar(64)  DEFAULT '' COMMENT '任务组名',
    method_name     varchar(500) DEFAULT '' COMMENT '任务方法',
    method_params   varchar(50)  DEFAULT NULL COMMENT '方法参数',
    cron_expression varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
    misfire_policy  char(1)      DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
    concurrent      char(1)      DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
    status          char(1)      DEFAULT '0' COMMENT '状态（0正常 1暂停）',
    create_by       varchar(64)  DEFAULT '' COMMENT '创建者',
    create_time     datetime COMMENT '创建时间',
    update_by       varchar(64)  DEFAULT '' COMMENT '更新者',
    update_time     datetime COMMENT '更新时间',
    remark          varchar(500) DEFAULT '' COMMENT '备注信息',
    PRIMARY KEY (job_id, job_name, job_group)
) ENGINE = innodb AUTO_INCREMENT = 100 DEFAULT CHARSET = utf8 COMMENT = '定时任务调度表';

-- ----------------------------
-- 17、定时任务调度日志表
-- ----------------------------
DROP TABLE IF EXISTS sys_job_log;
CREATE TABLE sys_job_log
(
    job_log_id     int(11)     NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
    job_name       varchar(64) NOT NULL COMMENT '任务名称',
    job_group      varchar(64) NOT NULL COMMENT '任务组名',
    method_name    varchar(500) COMMENT '任务方法',
    method_params  varchar(50) DEFAULT NULL COMMENT '方法参数',
    job_message    varchar(500) COMMENT '日志信息',
    status         char(1)     DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
    exception_info text COMMENT '异常信息',
    create_time    datetime COMMENT '创建时间',
    PRIMARY KEY (job_log_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '定时任务调度日志表';

-- ----------------------------
-- 18、通知公告表
-- ----------------------------
DROP TABLE IF EXISTS sys_notice;
CREATE TABLE sys_notice
(
    notice_id      int(4)      NOT NULL AUTO_INCREMENT COMMENT '公告ID',
    notice_title   varchar(50) NOT NULL COMMENT '公告标题',
    notice_type    char(1)     NOT NULL COMMENT '公告类型（1通知 2公告）',
    notice_content varchar(2000) DEFAULT NULL COMMENT '公告内容',
    status         char(1)       DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
    create_by      varchar(64)   DEFAULT '' COMMENT '创建者',
    create_time    datetime COMMENT '创建时间',
    update_by      varchar(64)   DEFAULT '' COMMENT '更新者',
    update_time    datetime COMMENT '更新时间',
    remark         varchar(255)  DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (notice_id)
) ENGINE = innodb DEFAULT CHARSET = utf8 COMMENT = '通知公告表';
