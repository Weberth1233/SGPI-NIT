package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.PasswordResetToken;
import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface TokenRepository extends JpaRepository<PasswordResetToken, Long> {
    Optional<PasswordResetToken> findByToken(String token);
    @Transactional
    void deleteByUser(User user);
}
