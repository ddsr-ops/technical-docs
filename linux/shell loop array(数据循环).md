首先创建一个数组 array=( A B C D 1 2 3 4)
###1.标准的for循环

```
for(( i=0;i<${#array[@]};i++)) do
#${#array[@]}获取数组长度用于循环
echo ${array[i]};
done;
```

###2.for … in
遍历（不带数组下标）：

```
for element in ${array[@]}
#也可以写成for element in ${array[*]}
do
echo $element
done
```

遍历（带数组下标）：

```
for i in "${!arr[@]}";   
do   
    printf "%s\t%s\n" "$i" "${arr[$i]}"  
done
```  

###3.While循环法：

```
i=0  
while [ $i -lt ${#array[@]} ]  
#当变量（下标）小于数组长度时进入循环体
do  
    echo ${ array[$i] }  
    #按下标打印数组元素
    let i++  
done  
```