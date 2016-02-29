![](img/merge-cells.png)


|      null  |            merge         ||



|  title1    |   title2    |   title3    |
|  ------    |   :------:  |   ------:   |
|  cell1     |        merge-cells       ||
|  cell2     |   center    |   right     |



  |         |           merge          ||
  title1    |   title2    |   title3    |
  ------    |   :------:  |   ------:   |
  cell1     |        merge-cells       ||
  cell2     |   center    |   right     |
  cell3     |        merge-cells       ||



  ||            || Column Header One || Column Header Two || Column Header Three || if this line is followed by a line of ||--|| then it is a header, also, Row Headers are indicated by an optional *empty* A1 cell
  ||-----------:||:------------------||:-----------------:||--------------------:|| : to indicate default column alignment as per ME
  ||Row Hdr 1   ||Left Aligned||Centre Aligned||Right Aligned|| whitespace should not matter
  ||Row Hdr 2   |>|colspan the next cell                  ||Row 2, Col 3         || Merge the cells in Col1 and 2
  ||Row Hdr 3   |>>|colspan the next two cells                                   || Merge the cells in Col1, 2, and 3
  ||Row Hdr 4   |v|rowspan the next cell down||           || Column 3            || rowspan on col1 and an empty cell
  ||Row Hdr 5   ||                   || Column 2          || Column 3            ||
  ||Row Hdr 6   |vv|merge down 2     |>| Merge right                             ||
  ||Row Hdr 7   ||                   || Column 2         :||: Column 3           || Row7 Col2 RAlign, Col3 LAlign (in exception to column default)
  ||Row Hdr 8   ||                   || Column 2         :||: Column 3           ||



||< th left aligned ||= th center aligned ||> th right aligned
|< td left aligned |= td center aligned |> td right aligned
|| th |<2 td with a cell span of 2 left aligned
| td ||2 th with a cell span of 2
| |2 blank cells require a space between the pipes when there are multiple columns or just the pipes when alone.
|3
||3



||< th left aligned ||= th center aligned ||> th right aligned
|<  td left aligned |=  td center aligned |>  td right aligned
||  th              |<2 td with a cell span of 2 left aligned
|   td              ||2 th with a cell span of 2
|                   |2  blank cells require a space between the pipes when there are multiple columns or just the pipes when alone.
|3
||3



| First Header  | Second Header | Third Header         |
| :------------ | :-----------: | -------------------: |
| First row     | Data          | Very long data entry |
| Second row    | **Cell**      | *Cell*               |
| Third row     | Cell that spans across two columns  ||
[Table caption, works as a reference][section-mmd-tables-table1]
