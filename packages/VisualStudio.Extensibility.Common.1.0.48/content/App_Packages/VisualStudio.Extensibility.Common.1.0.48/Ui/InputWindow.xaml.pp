<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<Ui:SkinnedWindow x:Class="$rootnamespace$.Ui.InputWindow"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
                  xmlns:Ui="clr-namespace:$rootnamespace$.Ui"
                  mc:Ignorable="d" 
             Title="Input window" WindowStartupLocation="CenterScreen" SizeToContent="Height" Width="400"
             x:Name="inputWindow" Loaded="inputWindow_Loaded">
    <DockPanel>
        <StackPanel DockPanel.Dock="Bottom" Orientation="Horizontal" HorizontalAlignment="Right">
            <Button Width="75" Name="btnOk" IsDefault="True" Padding="8 2" Margin="8 0 4 8" Click="btnOk_Click">OK</Button>
            <Button Width="75" Name="btnCancel" IsCancel="True" Padding="8 2" Margin="4 0 8 8" Click="btnCancel_Click">Cancel</Button>
        </StackPanel>
        <TextBox DockPanel.Dock="Bottom" Name="tInput" Margin="8" Text="{Binding Input, ElementName=inputWindow}" TabIndex="0" />
        <TextBlock DockPanel.Dock="Top" TextWrapping="Wrap" Margin="8 0 8 8" Text="{Binding Message, ElementName=inputWindow}"/>
    </DockPanel>
</Ui:SkinnedWindow>
