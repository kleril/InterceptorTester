<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<Window x:Class="$rootnamespace$.Ui.ItemSelection.ItemSelectionWindow"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008" 
             mc:Ignorable="d" ResizeMode="NoResize" 
             ShowInTaskbar="False" WindowStyle="None" SizeToContent="WidthAndHeight" 
             SnapsToDevicePixels="True" AllowsTransparency="True"
             Activated="SnippetOptionsControl_OnActivated"
             PreviewKeyDown="SnippetOptionsControl_OnPreviewKeyDown"
             PreviewMouseWheel="SnippetOptionsControl_OnPreviewMouseWheel">
    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="../../Resources/WPFResources.xaml"/>
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>
    <Border CornerRadius="5" BorderThickness="3">
        <Border.BorderBrush>
            <SolidColorBrush Opacity="0.35" Color="#c6daec"/>
        </Border.BorderBrush>
        <Border CornerRadius="2" Background="#f8fcff" BorderBrush="#d5d8db" BorderThickness="1">
            <DockPanel Margin="4">
                <DockPanel DockPanel.Dock="Top">
                    <Image Name="imgCaption" Width="16" Height="16"/>
                    <TextBlock Margin="4 2 4 2" Name="lblCaption" Text="BUGOGA!" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                    <TextBox Name="tFilter" MinWidth="150" Margin="4 2 0 2" BorderThickness="1" TextChanged="tFilter_TextChanged" LostKeyboardFocus="TFilter_OnLostFocus" />
                </DockPanel>

                <ListView Name="lstOptions" DockPanel.Dock="Top" PreviewMouseLeftButtonDown="LstOptions_OnMouseLeftButtonDown" SelectionChanged="LstOptions_OnSelectionChanged">
                    <ListView.View>
                        <GridView AllowsColumnReorder="False">
                            <GridView.Columns>
                                <GridViewColumn>
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Image Margin="0 4" Source="{Binding Image}" Width="16" Height="16"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn>
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock VerticalAlignment="Center" Text="{Binding Text}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn>
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Margin="8 2 2 2" VerticalAlignment="Center" Text="{Binding Description}" FontSize="10" Foreground="Gray"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                            </GridView.Columns>
                            <GridView.ColumnHeaderContainerStyle>
                                <Style TargetType="GridViewColumnHeader">
                                    <Setter Property="Visibility" Value="Collapsed"/>
                                </Style>
                            </GridView.ColumnHeaderContainerStyle>
                        </GridView>
                    </ListView.View>
                    <!--<ListBox.ItemTemplate>
                        <DataTemplate>
                            <StackPanel Orientation="Horizontal">
                                
                            </StackPanel>
                        </DataTemplate>
                    </ListBox.ItemTemplate>-->
                </ListView>
            </DockPanel>
        </Border>
    </Border>
</Window>
