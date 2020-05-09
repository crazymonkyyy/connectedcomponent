T*[][] connectedcomponentfilter(alias filter,T,size_t x,size_t y)(ref T[x][y] data){
  size_t groupidgen;
  import ringarray;
  import smart2darray;
  alias elemtype=stable!(grouping!(T*));
  ring!(elemtype*,true,x+y,donothing) unstables;//x+y is a randomly choosen heristic, that seems like a good idea at this moment
  array2d!(elemtype,x,y) groupfindingdata;
  //import std.stdio; "hi".writeln;
  init:
  foreach(i;0..x){
  foreach(j;0..y){//didnt check if this is the cashe friendly order
    groupfindingdata[i,j]=&data[i][j];
  }}
  //unstables.tail=unstables.head;
  
  groupandstablize: bool allstable=true;
  foreach(i;0..x){
  foreach(j;0..y){
    import std.stdio; writeln(i,",",j);
    void group(vec2)(vec2 a){
      alias g=groupfindingdata;
      if(a.x+1<x){g[a.x,a.y]=*g[a.x+1,a.y  ];}
      if(a.x-1>0){g[a.x,a.y]=*g[a.x-1,a.y  ];}
      if(a.y+1<y){g[a.x,a.y]=*g[a.x  ,a.y+1];}
      if(a.y-1>0){g[a.x,a.y]=*g[a.x  ,a.y-1];}
    }
    while(!unstables.empty){
      allstable=false;
      group(groupfindingdata[unstables]);
    }
    {
      struct vec2{int x; int y;} 
      group(vec2(x,y));
    }
  }}
  
  T*[][] bar;
  return bar;
}
unittest{
  auto iseven(int a){return a%2==0;}
  int[3][3] foo=[
    [1,2,3],
    [1,2,3],
    [1,2,3] ];
  auto bar=connectedcomponentfilter!(iseven)(foo);
}