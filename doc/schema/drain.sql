-- drain 城市排水防涝泵站运行与汛期调度管理 -- schema (hai-004)
-- 列名与基线实体契约（@TableName/@TableField）逐列对齐，改列必须同步实体。
-- 库：hai_004

CREATE TABLE IF NOT EXISTS t_drain_dispatch_bill (
  id bigint NOT NULL COMMENT '主键',
  bill_no varchar(64) DEFAULT NULL COMMENT '调度申请号',
  node_no int DEFAULT NULL COMMENT '当前签核节点 0..2',
  sign_mode int DEFAULT NULL COMMENT '签核模式 0或签 1会签',
  need_count int DEFAULT NULL COMMENT '本节点应签人数',
  sign_count int DEFAULT NULL COMMENT '本节点已签人数',
  status int DEFAULT NULL COMMENT '签批单状态 0审批中 1批准强排 2已驳回',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='泵站强排调度签批单';

CREATE TABLE IF NOT EXISTS t_drain_level_std (
  id bigint NOT NULL COMMENT '主键',
  rule_code varchar(64) DEFAULT NULL COMMENT '判线代号',
  rule_name varchar(128) DEFAULT NULL COMMENT '判线名称',
  th1_max decimal(12,2) DEFAULT NULL COMMENT '一档起排水位上限',
  th2_max decimal(12,2) DEFAULT NULL COMMENT '二档起排水位上限',
  th3_max decimal(12,2) DEFAULT NULL COMMENT '三档起排水位上限',
  eff_start datetime DEFAULT NULL COMMENT '生效起始时刻',
  eff_end datetime DEFAULT NULL COMMENT '失效截止时刻(不含)',
  priority int DEFAULT NULL COMMENT '取优序号(数值越大越优先)',
  status int DEFAULT NULL COMMENT '判线状态 0现行 1已作废',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='泵站起排判线标准';

CREATE TABLE IF NOT EXISTS t_drain_meter_row (
  id bigint NOT NULL COMMENT '主键',
  batch_no varchar(64) DEFAULT NULL COMMENT '汇交批次号',
  row_no int DEFAULT NULL COMMENT '远传报文行次',
  item_code varchar(64) DEFAULT NULL COMMENT '计量点编码',
  qty decimal(12,2) DEFAULT NULL COMMENT '本期远传读数',
  status int DEFAULT NULL COMMENT '行状态 0待对账 1已对平 2已剔除',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='泵站远传计量明细行';

CREATE TABLE IF NOT EXISTS t_drain_patrol_task (
  id bigint NOT NULL COMMENT '主键',
  item_no varchar(64) DEFAULT NULL COMMENT '巡检任务编号',
  due_at datetime DEFAULT NULL COMMENT '到期时刻',
  amount decimal(12,2) DEFAULT NULL COMMENT '应巡点位数',
  status int DEFAULT NULL COMMENT '状态 0待派 1已派 2无法派单',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='汛期值守巡检任务条目';

CREATE TABLE IF NOT EXISTS t_drain_run_record (
  id bigint NOT NULL COMMENT '主键',
  bill_no varchar(64) DEFAULT NULL COMMENT '运行单号',
  site_id int DEFAULT NULL COMMENT '受录泵站',
  site_no varchar(64) DEFAULT NULL COMMENT '泵站编号',
  qty decimal(12,2) DEFAULT NULL COMMENT '机组实际运行时长(小时)',
  fine_amt decimal(12,2) DEFAULT NULL COMMENT '电耗核算费(元)',
  grade_level int DEFAULT NULL COMMENT '运行评定档',
  status int DEFAULT NULL COMMENT '状态 0待复核 1已复核 2已封存',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='机组运行记录单';

CREATE TABLE IF NOT EXISTS t_drain_station (
  id bigint NOT NULL COMMENT '主键',
  site_no varchar(64) DEFAULT NULL COMMENT '泵站编号',
  site_name varchar(128) DEFAULT NULL COMMENT '泵站名称',
  site_type varchar(32) DEFAULT NULL COMMENT '泵站类别',
  road_name varchar(128) DEFAULT NULL COMMENT '管辖片区',
  th1_max decimal(12,2) DEFAULT NULL COMMENT '本泵站考核一档上限',
  th2_max decimal(12,2) DEFAULT NULL COMMENT '本泵站考核二档上限',
  th3_max decimal(12,2) DEFAULT NULL COMMENT '本泵站考核三档上限',
  status int DEFAULT NULL COMMENT '档案状态 0在用 1已停用',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='在册泵站档案';

CREATE TABLE IF NOT EXISTS t_drain_work_order (
  id bigint NOT NULL COMMENT '主键',
  biz_no varchar(64) DEFAULT NULL COMMENT '作业单号',
  stage int DEFAULT NULL COMMENT '当前环节 0..4',
  status int DEFAULT NULL COMMENT '作业单状态 0在办 1办结确认 2退回重办',
  content varchar(255) DEFAULT NULL COMMENT '推进记录',
  last_action varchar(64) DEFAULT NULL COMMENT '最近一次推进动作',
  del_flag int DEFAULT '0' COMMENT '删除标记 0正常 1删除',
  create_by varchar(64) DEFAULT NULL COMMENT '创建者',
  create_time datetime DEFAULT NULL COMMENT '创建时间',
  update_by varchar(64) DEFAULT NULL COMMENT '更新者',
  update_time datetime DEFAULT NULL COMMENT '更新时间',
  remark varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='排涝抢险作业单';
