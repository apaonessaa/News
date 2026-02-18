package com.app.news.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Entity
public class Image
{
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long imgID;

    @NotNull @NotBlank
    @Getter
    private String filename;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="artID")
    @Getter @Setter
    private Article article;

    protected Image(){}

    public Image(String filename) {
        this.filename = filename;
    }
}
