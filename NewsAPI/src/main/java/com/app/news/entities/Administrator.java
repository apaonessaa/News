package com.app.news.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Administrator
{
    @Id
    private String email;
    private String givenName;
    private String familyName;

    protected Administrator(){}
}
