package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {

}
