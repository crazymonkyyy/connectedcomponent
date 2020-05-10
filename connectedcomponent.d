T*[][] connectedcomponentfilter(string filter,T,size_t x,size_t y)(ref T[x][y] data){
  mixin(import("group.mix"));
  size_t groupidgen;
  mixin(import("stable.mix"));
  alias selfgroupingpointers=stable!(grouping!(T*,filter));
  
  import ringarray;
  ring!(selfgroupingpointers*,true,x+y,drophalf) unstables;//x+y is an untested heristic
  
  import smart2darray;
  array2d!(selfgroupingpointers,x,y) groupdata;
  
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
      if(a.x<x-1){g[a.x,a.y]=*g[a.x+1,a.y  ];}
      if(a.x>0  ){g[a.x,a.y]=*g[a.x-1,a.y  ];}
      if(a.y<y-1){g[a.x,a.y]=*g[a.x  ,a.y+1];}
      if(a.y>0  ){g[a.x,a.y]=*g[a.x  ,a.y-1];}
    }
    while(!unstables.empty){
      allstable=false;
      group(groupdata[unstables]);
    }
    {
      struct vec2{size_t x; size_t y;} 
      group(vec2(i,j));
    }
  }}
  if(!allstable){goto group;}
  
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
}
