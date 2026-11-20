--6. The catalogue team needs to see everything under a part of the tree. Using a
--recursive query, list all categories in the subtree rooted at 'Computers' at any depth, with
--how deep each sits and a readable path from Computers. Required output: category_id,
--category_name, depth_level, category_path.--SELECT * FROM dim_category WHERE category_name ='Computers';WITH CategoryTree AS
(
    -- Anchor member: Start with Computers
    SELECT
        category_id,
        category_name,
        parent_category_id,
        0 AS depth_level,
        CAST(category_name AS VARCHAR(MAX)) AS category_path
    FROM dim_category
    WHERE category_name = 'Computers'
      AND parent_category_id IS NULL

    UNION ALL

    -- Recursive member: Find child categories
    SELECT
        c.category_id,
        c.category_name,
        c.parent_category_id,
        ct.depth_level + 1,
        CAST(
            ct.category_path + ' > ' + c.category_name
            AS VARCHAR(MAX)
        ) AS category_path
    FROM dim_category c
    INNER JOIN CategoryTree ct
        ON c.parent_category_id = ct.category_id
)

SELECT
    category_id,
    category_name,
    depth_level,
    category_path
FROM CategoryTree
ORDER BY category_path
OPTION (MAXRECURSION 100);