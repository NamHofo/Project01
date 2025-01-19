# Project 01

1. Title: Project 01
2. Thời gian
    - Ngày bắt đầu: 17/1/2025
    - Ngày hoàn thành: 18/1/2025
3. Công cụ sử dụng csvkit

### 1. **`csvcut`**

Dùng để chọn các cột từ tệp CSV.

**Cú pháp**:

csvcut -c <cột cần chọn> <file.csv>

**Ví dụ**: Chọn các cột `name`, `age` từ tệp CSV:

csvcut -c name,age data.csv

### 2. **`csvgrep`**

Dùng để lọc các dòng dữ liệu trong tệp CSV theo điều kiện cụ thể.

**Cú pháp**:

csvgrep -c <cột> -m <giá trị tìm kiếm> <file.csv>

**Ví dụ**: Lọc các dòng có giá trị `John` trong cột `name`:

csvgrep -c name -m John data.csv

### 3. **`csvsort`**

Dùng để sắp xếp các dòng trong tệp CSV theo một hoặc nhiều cột.

**Cú pháp**:

csvsort -c <cột> -r <file.csv>

**Ví dụ**: Sắp xếp dữ liệu theo cột `age` theo thứ tự giảm dần:

csvsort -c age -r data.csv

### 4. **`csvstat`**

Dùng để hiển thị các thống kê cơ bản của tệp CSV, như số lượng dòng, cột, kiểu dữ liệu, giá trị tối thiểu và tối đa của các cột số.

**Cú pháp**: 

csvstat <file.csv>

**Ví dụ**:      

csvstat data.csv

### 5. **`csvsql`**

Dùng để thực thi các câu lệnh SQL trên dữ liệu CSV. Điều này rất hữu ích khi bạn muốn làm việc với CSV như một cơ sở dữ liệu.

**Cú pháp**:

csvsql --query "<SQL query>" <file.csv>

**Ví dụ**: Lọc các dòng có `age` lớn hơn 30 bằng SQL:

csvsql --query "SELECT * FROM data WHERE age > 30" data.csv

### 6. **`csvlook`**

Dùng để hiển thị dữ liệu trong tệp CSV theo dạng bảng đẹp mắt, dễ đọc trong terminal.

**Cú pháp**:

csvlook <file.csv>

**Ví dụ**:

csvlook data.csv

### 7. **`csvjoin`**

Dùng để nối (join) hai tệp CSV lại với nhau, giống như `JOIN` trong SQL.

**Cú pháp**:

csvjoin -c <cột chung> <file1.csv> <file2.csv>

**Ví dụ**: Nối hai tệp CSV `file1.csv` và `file2.csv` theo cột `id`:

csvjoin -c id file1.csv file2.csv

### 8. **`csvclean`**

Dùng để làm sạch tệp CSV, sửa các vấn đề như dấu ngoặc kép không khớp hoặc dòng trống.

**Cú pháp**:

csvclean <file.csv>

**Ví dụ**:

csvclean data.csv

### 9. **`csvstack`**

Dùng để ghép nhiều tệp CSV thành một tệp duy nhất.

**Cú pháp**:

csvstack <file1.csv> <file2.csv> > <output.csv>

**Ví dụ**: Ghép các tệp `file1.csv` và `file2.csv` thành tệp `output.csv`:

csvstack file1.csv file2.csv > output.csv

### 10. **`csvcut` - Chọn và xuất ra tệp mới**

Dùng để chọn các cột từ tệp CSV và xuất kết quả ra tệp mới.

**Cú pháp**:

csvcut -c <cột> <file.csv> > <output.csv>

**Ví dụ**:

csvcut -c name,age data.csv > selected_columns.csv

### 11. **`csvtranspose`**

Dùng để hoán đổi các hàng và cột trong tệp CSV.

**Cú pháp**:

csvtranspose <file.csv>

**Ví dụ**:

csvtranspose data.csv

1. Các yêu cầu:
- Thay đổi pwd bằng cmd: cd /home/hofonam/Documents/UniGap/Project01
- Tải data về file sử dụng câu lệnh: curl -O [https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv](https://raw.githubusercontent.com/yinghaoz1/tmdb-movie-dataset-analysis/master/tmdb-movies.csv)
    
    để tải xuống file và đặt tên file giống với tên file trên server
    
- Thực hiện các yêu cầu trong bài

### 1) Sắp xếp các bộ phim theo ngày phát hành giảm dần rồi lưu ra một file mới

-Loại bỏ dòng trống bằng lệnh : grep -v '^$' tmdb-movies.csv > data1.csv 

-Khi sử dụng dấu “ , “ để tách các cột có khó khăn đó là trong 1 số cột, nội dung trong cột cũng chứa dấu “,” và trong một số cột đó nội dung không được bọc bởi dấu “”. Để xử lý vấn đề này, sử dụng hàm awk để xét các nội dung các cột chứa dấu , nhưng không được bao bởi dấu “” thì sẽ cho  phần nội dung đó vào dấu “”:

awk -F',' '{
for (i=1; i<=NF; i++) {
if ($i ~ /,/) {
printf "\"%s\"", $i
} else {
printf "%s", $i
}
In dấu phẩy giữa các trường, trừ trường cuối cùng
if (i < NF) printf ","
else print ""
}
}' data1.csv > data2.csv

Dùng công cụ csvsort trong package csvkit để sort data theo release_date:
     csvsort -c 'release_date' -r data2.csv > sort_by_date.csv

### 2) Lọc ra các bộ phim có đánh giá trung bình trên 7.5 rồi lưu ra một file mới

Sử dụng lệnh cscsql để chạy truy vấn lọc ra từ cột vote_average 
csvsql --query "SELECT * FROM data2 WHERE vote_average > 7.5" data2.csv > filtered_vote.csv

### 3) Tìm ra phim nào có doanh thu cao nhất và doanh thu thấp nhất

csvsql --query "SELECT * FROM data2 WHERE revenue = (SELECT MAX(revenue) FROM data2)" data2.csv
csvsql --query "SELECT * FROM data2 WHERE revenue = (SELECT MIN(revenue) FROM data2)" data2.csv

### 4) Tính tổng doanh thu tất cả các bộ phim

csvsql --query "SELECT SUM(revenue) FROM data2" data2.csv

### 5) Top 10 bộ phim đem về lợi nhuận cao nhất

csvsql --query "SELECT * FROM data2 ORDER BY revenue DESC LIMIT 10" data2.csv

### 6) Đạo diễn nào có nhiều bộ phim nhất và diễn viên nào đóng nhiều phim nhất

csvsql --query "
SELECT director, COUNT(original_title) AS movie_count
FROM data2
GROUP BY director
ORDER BY movie_count DESC LIMIT 1" data2.csv

### 6) Diễn viên nào đóng nhiều phim nhất

csvcut -c cast data2.csv| grep -v ' " ' | sed 's/,/;/g' | tr '|' '\n' | awk 'NR >= 1 {print "\"" $0 "\""}’>cast.csv

- grep -v ‘ “ ‘ : Loại bỏ tên diễn viên chứa dấu “
- swd ‘s/,/;/g’ : Chuyển đổi tên chứa ‘,’ thành dấu ‘;’
- tr ‘|’ ‘\n’ : Phân tách dựa trên dấu ‘|’
- awk 'NR >= 1 {print "\"" $0 "\""}’  : Đặt các tên diễn viên và cast vào trong dấu “” trên từng dòng

và xuất ra file cast.csv

csvsql --query "
SELECT \"cast\", COUNT(\"cast\") AS NumberOfFilms
FROM cast
GROUP BY \"cast\"
ORDER BY NumberOfFilms DESC
LIMIT 1" cast.csv

Chạy query để tìm diễn viên dóng phim nhiều nhất với tên cột là “cast”

### 7) Thống kê số lượng phim theo các thể loại. Ví dụ có bao nhiêu phim thuộc thể loại Action, bao nhiêu thuộc thể loại Family, ….

#Trích xuất ra 1 danh sách các thể loại phim xuất ra 1 file genre.csv
csvcut -c genres data2.csv| grep -v '"' | sed 's/,/;/g' | tr '|' '\n' | awk 'NR >= 1 {print "\"" $0 "\""}' >genres.csv

#Thể loại nhiều nhất bằng cách dùng query trên file genre.csv
csvsql --query "
SELECT \"genres\", COUNT(\"genres\") AS NumberOfGenres
FROM genres
GROUP BY \"genres\"
ORDER BY NumberOfGenres DESC" genres.csv

### 8) Idea của bạn để có thêm những phân tích cho dữ liệu?

### **Phân tích theo thể loại (Genres)**

**Doanh thu theo thể loại:** Xem xét thể loại phim nào có doanh thu cao nhất hoặc thấp nhất.

### **Thời gian phát hành (Release Date)**

- **Phim phát hành vào các mùa nào có doanh thu cao nhất?** Phân tích theo tháng hoặc theo năm để xác định những khoảng thời gian phát hành phim có thể giúp dự đoán doanh thu.
- **Xu hướng theo năm**

### **Phân tích dựa trên đạo diễn (Director) và dàn diễn viên (Cast)**

- **Ảnh hưởng của đạo diễn và dàn diễn viên:** Tìm hiểu liệu đạo diễn hoặc các diễn viên nổi tiếng có ảnh hưởng đến doanh thu hay không.
- **Phân tích dàn diễn viên:** Xem dàn diễn viên có ảnh hưởng đến sự thành công của bộ phim không.
