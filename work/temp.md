For example, for a given pattern b+ c and a data stream b1 b2 b3 c, the differences between these four skip strategies are as follows:

|Skip Strategy	|Result	|Description|
| :----: | :----: | :----: |
|NO_SKIP	|b1 b2 b3 c; b2 b3 c; b3 c|After found matching b1 b2 b3 c, the match process will not discard any result.|
|SKIP_TO_NEXT	|b1 b2 b3 c;b2 b3 c;b3 c|After found matching b1 b2 b3 c, the match process will not discard any result, because no other match could start at b1.|
|SKIP_PAST_LAST_EVENT	|b1 b2 b3 c|After found matching b1 b2 b3 c, the match process will discard all started partial matches.|
|SKIP_TO_FIRST|	b1 b2 b3 c;b2 b3 c;b3 c|After found matching b1 b2 b3 c, the match process will try to discard all partial matches started before b1, but there are no such matches. Therefore nothing will be discarded.|
|SKIP_TO_LAST|b1 b2 b3 c;b3 c|After found matching b1 b2 b3 c, the match process will try to discard all partial matches started before b3. There is one such match b2 b3 c|

The aforementioned example is right? If so,  give me a full java code snippet to illustrate the example in the context of using socket as Flink data source.   