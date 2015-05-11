<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<Window x:Class="$rootnamespace$.Ui.ProjectSelector.ProjectSelectionWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:projectSelector="clr-namespace:$rootnamespace$.Ui.ProjectSelector" Title="ProjectSelectionWindow" Height="400" Width="400" ShowInTaskbar="False" WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    <Window.Resources>
        <projectSelector:ItemTypeBoolConverter x:Key="itemTypeBoolConverter"/>
    </Window.Resources>
    <DockPanel Margin="8">
        <TextBlock Name="tText" DockPanel.Dock="Top" TextWrapping="Wrap">Select a project or folder where generated client files will be placed. You can always change this location in solution options.</TextBlock>
        <Grid DockPanel.Dock="Bottom">
            <Button Visibility="Hidden" Name="btnCreateFolder" HorizontalAlignment="Left" Margin="4" Padding="8 2" IsEnabled="{Binding ElementName=selector, Path=SelectedItem, Converter={StaticResource itemTypeBoolConverter}}" Click="btnCreateFolder_Click">Create folder</Button>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                <Button Width="75" Margin="4" Padding="8 2" Name="btnOk" IsDefault="True" Click="btnOk_Click">OK</Button>
                <Button Width="75" Margin="4" Padding="8 2" Name="btnCancel" IsCancel="True" Click="btnCancel_Click">Cancel</Button>
            </StackPanel>
        </Grid>
        <projectSelector:ProjectSelectionControl Margin="0 8 0 0" x:Name="selector" DataContext="{Binding}" DockPanel.Dock="Top"/>
    </DockPanel>
</Window>
