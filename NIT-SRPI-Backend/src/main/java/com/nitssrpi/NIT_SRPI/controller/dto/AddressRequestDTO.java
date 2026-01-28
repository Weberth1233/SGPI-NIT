package com.nitssrpi.NIT_SRPI.controller.dto;

public record AddressRequestDTO(String zipCode,
                                String street,
                                String number,
                                String complement,
                                String neighborhood,
                                String city,
                                String state) {

}
