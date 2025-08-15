package org.example.mono.repositories;

import org.example.mono.models.Wallet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;


public interface WalletRepo extends JpaRepository<Wallet,Integer> {
        @Query("SELECT w FROM Wallet w LEFT JOIN FETCH w.transactions WHERE w.userId = :userId")
        Wallet findByUserId(Integer userId);
}

