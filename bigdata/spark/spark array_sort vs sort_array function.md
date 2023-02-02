#array_sort
array_sort(expr, func) - Sorts the input array. If func is omitted, sort in ascending order. The elements of the input array must be orderable. NaN is greater than any non-NaN elements for double/float type. Null elements will be placed at the end of the returned array. Since 3.0.0 this function also sorts and returns the array based on the given comparator function. The comparator will take two arguments representing two elements of the array. It returns a negative integer, 0, or a positive integer as the first element is less than, equal to, or greater than the second element. If the comparator function returns null, the function will fail and raise an error.

Examples:
```
> SELECT array_sort(array(5, 6, 1), (left, right) -> case when left < right then -1 when left > right then 1 else 0 end);
 [1,5,6]
> SELECT array_sort(array('bc', 'ab', 'dc'), (left, right) -> case when left is null and right is null then 0 when left is null then -1 when right is null then 1 when left < right then 1 when left > right then -1 else 0 end);
 ["dc","bc","ab"]
> SELECT array_sort(array('b', 'd', null, 'c', 'a'));
 ["a","b","c","d",null]
```

#
sort_array
sort_array(array[, ascendingOrder]) - Sorts the input array in ascending or descending order according to the natural ordering of the array elements. NaN is greater than any non-NaN elements for double/float type. Null elements will be placed at the beginning of the returned array in ascending order or at the end of the returned array in descending order.

Examples:

```
> SELECT sort_array(array('b', 'd', null, 'c', 'a'), true);
 [null,"a","b","c","d"]
```