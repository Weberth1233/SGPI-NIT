package com.nitssrpi.NIT_SRPI.model;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FormStructure {

    private List<Field> fields;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Field {
        private String name;
        private String type;
        private boolean required;
    }
}
