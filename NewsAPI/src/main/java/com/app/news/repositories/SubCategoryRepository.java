package com.app.news.repositories;

import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SubCategoryRepository extends JpaRepository<SubCategory, Long>
{
    Optional<SubCategory> findByNameAndCategory(String name, Category cat);

    List<SubCategory> findAllByCategory(Category cat, Sort sort);
}
