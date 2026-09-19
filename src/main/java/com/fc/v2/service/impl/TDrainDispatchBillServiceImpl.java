package com.fc.v2.service.impl;

import org.springframework.stereotype.Service;

import com.fc.v2.mapper.auto.TDrainDispatchBillMapper;
import com.fc.v2.model.auto.TDrainDispatchBill;
import com.fc.v2.service.ITDrainDispatchBillService;

/**
 * 泵站强排调度签批单 Service业务层处理（approval-chain 形状：多阶段签批）
 *
 * @author fuce
 * @date 2026-09-14
 */
@Service
public class TDrainDispatchBillServiceImpl implements ITDrainDispatchBillService {

    private static final int MAX_NODE = 2;
    private static final int MODE_OR = 0;
    private static final int MODE_AND = 1;
    private static final int STATUS_RUNNING = 0;
    private static final int STATUS_PASS = 1;
    private static final int STATUS_VETO = 2;

    @javax.annotation.Resource
    private TDrainDispatchBillMapper drainDispatchBillMapper;

    @Override
    public TDrainDispatchBill selectTDrainDispatchBillById(Long id) {
        return this.drainDispatchBillMapper.selectById(id);
    }

    @Override
    public TDrainDispatchBill approve(Long id, String approver, String comment) {
        TDrainDispatchBill r = this.drainDispatchBillMapper.selectById(id);
        if (r == null || approver == null || approver.trim().isEmpty()) {
            return null;
        }
        r.setNodeNo(Integer.valueOf((r.getNodeNo() == null ? 0 : r.getNodeNo()) + 1));
        r.setStatus(Integer.valueOf(r.getNodeNo() >= MAX_NODE ? STATUS_PASS : STATUS_RUNNING));
        this.drainDispatchBillMapper.updateById(r);
        return r;
    }

    @Override
    public TDrainDispatchBill reject(Long id, String approver, String comment) {
        TDrainDispatchBill r = this.drainDispatchBillMapper.selectById(id);
        if (r == null) {
            return null;
        }
        this.drainDispatchBillMapper.updateById(r);
        return r;
    }

    @Override
    public TDrainDispatchBill rollback(Long id, String comment) {
        TDrainDispatchBill r = this.drainDispatchBillMapper.selectById(id);
        if (r == null) {
            return null;
        }
        int node = r.getNodeNo() == null ? 0 : r.getNodeNo();
        r.setNodeNo(Integer.valueOf(Math.max(0, node - 1)));
        this.drainDispatchBillMapper.updateById(r);
        return r;
    }
}
