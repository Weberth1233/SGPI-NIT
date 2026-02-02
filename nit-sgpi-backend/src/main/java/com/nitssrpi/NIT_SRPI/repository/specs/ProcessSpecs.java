package com.nitssrpi.NIT_SRPI.repository.specs;

import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import org.springframework.data.jpa.domain.Specification;

public class ProcessSpecs {

    public static Specification<Process> likeTitle(String title){
        return (root, query, cb) -> cb.like(cb.upper(root.get("title")), "%" + title.toUpperCase() + "%");
    }

    public static Specification<Process> equalStatusProcess(StatusProcess status){
        return (root, query, cb) -> cb.equal(root.get("status"), status);
    }

}
