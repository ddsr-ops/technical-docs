���ȴ���һ������ array=( A B C D 1 2 3 4)
###1.��׼��forѭ��

```
for(( i=0;i<${#array[@]};i++)) do
#${#array[@]}��ȡ���鳤������ѭ��
echo ${array[i]};
done;
```

###2.for �� in
���������������±꣩��

```
for element in ${array[@]}
#Ҳ����д��for element in ${array[*]}
do
echo $element
done
```

�������������±꣩��

```
for i in "${!arr[@]}";   
do   
    printf "%s\t%s\n" "$i" "${arr[$i]}"  
done
```  

###3.Whileѭ������

```
i=0  
while [ $i -lt ${#array[@]} ]  
#���������±꣩С�����鳤��ʱ����ѭ����
do  
    echo ${ array[$i] }  
    #���±��ӡ����Ԫ��
    let i++  
done  
```