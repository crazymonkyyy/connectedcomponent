T*[][] connectedcomponentfilter(string filter,T,size_t x,size_t y)(ref T[y][x] data){
  mixin(import("group.mix"));
  size_t groupidgen;
  mixin(import("stable.mix"));
  alias selfgroupingpointers=stable!(grouping!(T*,filter));
  
  import ringarray;
  ring!(selfgroupingpointers*,true,x+y,drophalf) unstables;//x+y is an untested heristic
  
  import smart2darray;
  array2d!(selfgroupingpointers,y,x) groupdata;
  
  init:
  foreach(i;0..x){//didnt check if this is cashe friendly
  foreach(j;0..y){
    groupdata[i,j]=&data[i][j];
  }}
  unstables.makeempty;
  
  group: bool allstable=true;
  foreach(i;0..x){
  foreach(j;0..y){
    void group(vec2)(vec2 a){
      alias g=groupdata;
      if(a.y>0  ){g[a.x  ,a.y-1].set(g[a.x,a.y].payload);}
      if(a.y<y-1){g[a.x  ,a.y+1].set(g[a.x,a.y].payload);}
      if(a.x<x-1){g[a.x+1,a.y  ].set(g[a.x,a.y].payload);}
      if(a.x>0  ){g[a.x-1,a.y  ].set(g[a.x,a.y].payload);}
    }
    while(!unstables.empty){
      import std.stdio; writeln("I'm running unstables");
      allstable=false;
      group(groupdata[unstables]);
    }
    {
      struct vec2{size_t x; size_t y;} 
      group(vec2(i,j));
    }
  }}
  if(!allstable){import std.stdio; writeln("I'm trying again");goto group;}
  
  aggergate://bad should be replaced with something n^2 without reallocations
  T*[][] output;
  size_t[size_t] grouplookup;
  foreach(i;0..x){
  foreach(j;0..y){
    if(groupdata[i,j].isnull){}
    else{
      if(!(groupdata[i,j].group in grouplookup)){
        grouplookup[groupdata[i,j].group]=output.length;
        output~=[[]];
      }
      output[grouplookup[groupdata[i,j].group]]~=groupdata[i,j].get;
    }
  }}
  return output;
}
unittest{
  int[3][3] foo=[
    [1,2,3],
    [1,2,3],
    [1,2,3] ];
  auto bar=connectedcomponentfilter!("*a%2==0")(foo);
  assert(
    bar[0][0]==&foo[0][1] &&
    bar[0][1]==&foo[1][1] &&
    bar[0][2]==&foo[2][1] 
  );
}
unittest{
  bool[5][6] foo=[
    [false,false,true ,false,true ] ,
    [false,true ,true ,false,false],
    [true ,true ,false,false,false],
    [false,false,false,true ,true ],
    [false,false,true ,true ,false],
    [true ,true ,false,true ,true ]
  ]; 
  auto bar=connectedcomponentfilter!("*a")(foo);
  import std.stdio; writeln("bar",bar);
  writeln("foo",foo);
  foreach(l;bar){
  foreach(e;l){
    *e=false;}}
  writeln("foo after",foo);
  bar=connectedcomponentfilter!("!*a")(foo);
  "---".writeln;
  //writeln(foo);
  assert(bar[0].length==30);
}
unittest{
  int[1][5] foo=[
    [1],
    [1],
    [1],
    [1],
    [1]
  ];
  auto bar=connectedcomponentfilter!("true")(foo);
  import std.stdio; writeln("bar",bar);
}
unittest{
  int[10][10] foo=[
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0],
    //[1,0,1,0,1,0,1,0,1,0],
    [1,0,1,0,1,0,1,0,1,0]
  ];
  auto bar=connectedcomponentfilter!("*a!=0")(foo);
  foreach(i,l;bar){
  foreach(j,e;l){
    *e=cast(int)(i*j);}}
  import std.stdio; "----".writeln;
  writeln("10,10 foo",foo);
}

unittest{
  int[10][10] foo=[
    [1,0,1,1,1,1,1,1,1,1],
    [1,0,1,0,0,0,0,0,0,1],
    [1,0,1,0,1,1,1,1,0,1],
    [1,0,1,0,1,0,0,1,0,1],
    [1,0,1,0,1,1,0,1,0,1],
    [1,0,1,0,1,1,0,1,0,1],
    [1,0,1,0,0,0,0,1,0,1],
    [1,0,1,1,1,1,1,1,0,1],
    [1,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1]
  ];
  import std.stdio; "----".writeln;
  auto bar=connectedcomponentfilter!("*a!=0")(foo);
  writeln("bar",bar);
  foreach(i,l;bar){
    writeln("hello");
    foreach(j,e;l){
      *e=cast(int)i+1;//cast(int)(j+i*100)+1;
      //writeln(*e);
  }}
  writeln("spiny",foo);
}
