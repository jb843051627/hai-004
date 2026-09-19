package com.fc.v2.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fc.v2.mapper.auto.TDrainWorkOrderMapper;
import com.fc.v2.model.auto.TDrainWorkOrder;
import com.fc.v2.service.ITDrainWorkOrderService;

/**
 * 排涝抢险作业单 Service业务层处理（state-machine 形状：单据流转）
 *
 * @author fuce
 * @date 2026-09-14
 */
@Service
public class TDrainWorkOrderServiceImpl implements ITDrainWorkOrderService {

    private static final int MAX_STAGE = 3;
    private static final int STATUS_ACTIVE = 1;
    private static final int STATUS_TERMINAL = 2;

    @javax.annotation.Resource
    private TDrainWorkOrderMapper drainWorkOrderMapper;

    @Override
    public TDrainWorkOrder selectTDrainWorkOrderById(Long id) {
        return this.drainWorkOrderMapper.selectById(id);
    }

    @Override
    public List<TDrainWorkOrder> selectTDrainWorkOrderList(QueryWrapper<TDrainWorkOrder> queryWrapper) {
        return this.drainWorkOrderMapper.selectList(queryWrapper);
    }

    @Override
    public TDrainWorkOrder advance(Long id, String remark) {
        TDrainWorkOrder r = this.drainWorkOrderMapper.selectById(id);
        if (r == null) {
            return null;
        }
        int st = r.getStage() == null ? 0 : r.getStage();
        r.setStage(Math.min(st + 2, MAX_STAGE));
        r.setStatus(STATUS_ACTIVE);
        r.setLastAction(remark);
        this.drainWorkOrderMapper.updateById(r);
        return r;
    }

    @Override
    public TDrainWorkOrder rollback(Long id, String remark) {
        TDrainWorkOrder r = this.drainWorkOrderMapper.selectById(id);
        if (r == null) {
            return null;
        }
        r.setStage(0);
        r.setStatus(STATUS_ACTIVE);
        r.setLastAction(remark);
        this.drainWorkOrderMapper.updateById(r);
        return r;
    }

    @Override
    public boolean updateContent(Long id, String remark) {
        TDrainWorkOrder r = this.drainWorkOrderMapper.selectById(id);
        if (r == null) {
            return false;
        }
        r.setContent(remark);
        return this.drainWorkOrderMapper.updateById(r) > 0;
    }

    @Override
    public boolean remove(Long id) {
        TDrainWorkOrder r = this.drainWorkOrderMapper.selectById(id);
        if (r == null) {
            return false;
        }
        return this.drainWorkOrderMapper.deleteById(id) > 0;
    }

}
