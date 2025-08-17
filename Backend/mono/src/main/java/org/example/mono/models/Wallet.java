package org.example.mono.models;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Wallet {
    @Id
    @GeneratedValue
    private Integer id;


    private double balance;


    private int userId;

    @OneToMany(mappedBy = "wallet", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JsonManagedReference
    List<Transaction> transactions;
}
