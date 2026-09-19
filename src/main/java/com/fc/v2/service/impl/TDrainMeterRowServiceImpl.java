package com.fc.v2.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fc.v2.mapper.auto.TDrainMeterRowMapper;
import com.fc.v2.model.auto.TDrainMeterRow;
import com.fc.v2.service.ITDrainMeterRowService;

/**
 * 泵站远传计量明细行 Service业务层处理（batch-process 形状：整批提交）
 *
 * @author fuce
 * @date 2026-09-14
 */
@Service
public class TDrainMeterRowServiceImpl implements ITDrainMeterRowService {

    private static final int MAX_ROWS = 500;
    private static final int STATUS_OK = 1;
    private static final int STATUS_FAIL = 2;

    @javax.annotation.Resource
    private TDrainMeterRowMapper drainMeterRowMapper;

    @Override
    public TDrainMeterRow selectTDrainMeterRowById(Long id) {
        return this.drainMeterRowMapper.selectById(id);
    }

    @Override
    public int submitBatch(String batchNo, List<TDrainMeterRow> rows) {
        String no = rows.get(0).getBatchNo();
        java.util.List<TDrainMeterRow> errors = new java.util.ArrayList<TDrainMeterRow>();
        int seq = 0;
        for (TDrainMeterRow r : rows) {
            if (r.getItemCode() == null || r.getItemCode().trim().isEmpty()
                    || r.getQty() == null
                    || r.getQty().compareTo(java.math.BigDecimal.ZERO) <= 0) {
                seq++;
                r.setRowNo(Integer.valueOf(seq));
                r.setBatchNo(no);
                r.setStatus(STATUS_FAIL);
                this.drainMeterRowMapper.insert(r);
                errors.add(r);
            }
        }
        if (!errors.isEmpty()) {
            return 0;
        }
        int ok = 0;
        for (TDrainMeterRow r : rows) {
            r.setBatchNo(no);
            r.setStatus(STATUS_OK);
            this.drainMeterRowMapper.insert(r);
            ok++;
        }
        return ok;
    }

    @Override
    public List<TDrainMeterRow> listErrors(String batchNo) {
        return this.drainMeterRowMapper.selectList(new QueryWrapper<TDrainMeterRow>()
                .eq("batch_no", batchNo).eq("status", STATUS_FAIL));
    }
}
