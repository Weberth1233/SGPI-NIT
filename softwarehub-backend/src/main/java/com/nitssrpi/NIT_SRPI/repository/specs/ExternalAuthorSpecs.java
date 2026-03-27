package com.nitssrpi.NIT_SRPI.repository.specs;

import com.nitssrpi.NIT_SRPI.model.ExternalAuthor;
import org.springframework.data.jpa.domain.Specification;

public class ExternalAuthorSpecs {

    public static Specification<ExternalAuthor> isActive() {
        return (root, query, cb) ->
                cb.equal(root.get("active"), true);
    }

    public static Specification<ExternalAuthor> likeFullName(String fullName){
        return (root, query, cb) -> cb.like(cb.upper(root.get("fullName")), "%" + fullName.toUpperCase() + "%");
    }

    public static Specification<ExternalAuthor> likeEmail(String email){
        return (root, query, cb) -> cb.like(cb.upper(root.get("email")), "%" + email.toUpperCase() + "%");
    }

    public static Specification<ExternalAuthor> equalCpf(String cpf){
        return (root, query, cb) -> cb.equal(root.get("cpf"), cpf);
    }

    public static Specification<ExternalAuthor> equalOwnerId(Long ownerId) {
        return (root, query, cb) -> {
            return cb.equal(root.get("owner").get("id"), ownerId);
        };
    }
}
