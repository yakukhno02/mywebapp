package com.kpi.mywebapp.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class ItemResponse {
    private Long id;
    private String name;
    private Integer quantity;
    @JsonProperty("created_at")
    private LocalDateTime createdAt;
}
