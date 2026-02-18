package com.app.news.repositories;

import com.app.news.entities.Administrator;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepository extends JpaRepository<Administrator, String>
{
}
