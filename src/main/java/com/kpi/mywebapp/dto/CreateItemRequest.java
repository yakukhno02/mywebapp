package com.kpi.mywebapp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CreateItemRequest {

    @NotBlank(message = "Name is required")
    String name;

    @NotNull
    Integer quantity;
}
