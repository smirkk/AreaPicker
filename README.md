# 1228-AreaPicker
中国城市地区选择器

使用：
1，把AreaPicker文件夹下地所有内容拖入到你的项目中；
2，在需要创建PickerView的地方，调用类方法创建PickerView，并遵守KJAreaPickerViewDelegate协议
   KJAreaPickerView *areaPickerView = [KJAreaPickerView areaPickerViewWithDelegate:self];
3，显示
   [areaPickerView showInView:self.view];
   
具体运用看demo
