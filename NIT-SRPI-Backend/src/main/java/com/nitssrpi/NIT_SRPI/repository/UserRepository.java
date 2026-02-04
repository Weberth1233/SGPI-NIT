package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

}
