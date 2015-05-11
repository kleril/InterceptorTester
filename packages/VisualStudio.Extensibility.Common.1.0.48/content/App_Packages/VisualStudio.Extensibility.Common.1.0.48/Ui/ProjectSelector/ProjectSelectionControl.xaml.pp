<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<UserControl x:Class="$rootnamespace$.Ui.ProjectSelector.ProjectSelectionControl"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
             xmlns:UI="clr-namespace:$rootnamespace$.Ui.ProjectSelector"
             mc:Ignorable="d" 
             d:DesignHeight="300" d:DesignWidth="300"
             x:Name="ctlSelector">
    <UserControl.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="../../Resources/WPFResources.xaml"/>
            </ResourceDictionary.MergedDictionaries>
            <UI:ItemTypeIconConverter x:Key="tic"/>
        </ResourceDictionary>
    </UserControl.Resources>
    <Grid>
        <TreeView Name="trProjects" ItemsSource="{Binding}" SelectedItemChanged="TrProjects_OnSelectedItemChanged">
            <TreeView.ItemContainerStyle>
                <Style TargetType="TreeViewItem" BasedOn="{StaticResource coolTreeViewItem}">
                    <Setter Property="IsExpanded" Value="True"/>
                </Style>
            </TreeView.ItemContainerStyle>
            <TreeView.ItemTemplate>
                <HierarchicalDataTemplate ItemsSource="{Binding Children}">
                    <HierarchicalDataTemplate.ItemContainerStyle>
                        <Style TargetType="TreeViewItem" BasedOn="{StaticResource coolTreeViewItem}">
                            <Setter Property="IsExpanded" Value="False"></Setter>
                        </Style>
                    </HierarchicalDataTemplate.ItemContainerStyle>
                    <StackPanel Orientation="Horizontal">
                        <Image Source="{Binding Item.Type, Converter={StaticResource tic}}" Width="16"/>
                        <TextBlock VerticalAlignment="Center" Margin="8 2 2 2" Text="{Binding Item.Name}"/>
                    </StackPanel>
                </HierarchicalDataTemplate>
            </TreeView.ItemTemplate>
        </TreeView>
    </Grid>
</UserControl>
