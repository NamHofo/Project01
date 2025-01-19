#!/bin/bash
echo "Bắt đầu quá trình xử lý dữ liệu"

# Loại bỏ các dòng trống
grep -v '^$' tmdb-movies.csv > data1.csv 

#Nếu nội dung của 1 trường chứa dấu " , " thì bao quanh trường đó bằng dấu " " 
awk -F',' '{
    for (i=1; i<=NF; i++) {
        if ($i ~ /,/) {
            printf "\"%s\"", $i
        } else {
            printf "%s", $i
        }
        # In dấu phẩy giữa các trường, trừ trường cuối cùng
        if (i < NF) printf ","
        else print ""
    }
}' data1.csv > data2.csv

#Dùng công cụ csvsort trong package csvkit để sort data
csvsort -c 'release_date' -r data2.csv > sort_by_date.csv

#Lọc ra các bộ phim có đánh giá trung bình trên 7.5
csvsql --query "SELECT * FROM data2 WHERE vote_average > 7.5" data2.csv > filtered_vote.csv

#Lọc ra các bộ phim có doanh thu cao nhất và thấp nhất
csvsql --query "SELECT * FROM data2 WHERE revenue = (SELECT MAX(revenue) FROM data2)" data2.csv 
csvsql --query "SELECT * FROM data2 WHERE revenue = (SELECT MIN(revenue) FROM data2)" data2.csv

#Tính tổng doanh thu tất cả bộ phim
csvsql --query "SELECT SUM(revenue) FROM data2" data2.csv

#Top 10 bộ phim đem về lợi nhuận cao nhất
csvsql --query "SELECT * FROM data2 ORDER BY revenue DESC LIMIT 10" data2.csv

#Đạo diễn có nhiều phim nhất
csvsql --query "
SELECT director, COUNT(original_title) AS movie_count 
FROM data2 
GROUP BY director 
ORDER BY movie_count DESC LIMIT 1" data2.csv

#Trích xuất ra 1 danh sách các diễn viên xuất ra 1 file cast.csv
csvcut -c cast data2.csv| grep -v '"' | sed 's/,/;/g' | tr '|' '\n' | awk 'NR >= 1 {print "\"" $0 "\""}' >cast.csv


#Diễn viên đóng nhiều phim nhất bằng cách dùng query trên file cast.csv
csvsql --query "
SELECT \"cast\", COUNT(\"cast\") AS NumberOfFilms
FROM cast
GROUP BY \"cast\"
ORDER BY NumberOfFilms DESC
LIMIT 1" cast.csv


#Trích xuất ra 1 danh sách các thể loại phim xuất ra 1 file genre.csv
csvcut -c genres data2.csv| grep -v '"' | sed 's/,/;/g' | tr '|' '\n' | awk 'NR >= 1 {print "\"" $0 "\""}' >genres.csv


#Thể loại nhiều nhất bằng cách dùng query trên file genre.csv
csvsql --query "
SELECT \"genres\", COUNT(\"genres\") AS NumberOfGenres
FROM genres
GROUP BY \"genres\"
ORDER BY NumberOfGenres DESC" genres.csv



