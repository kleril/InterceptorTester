<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<UserControl x:Class="$rootnamespace$.Updater.UpdateNotificationControl"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" 
             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
             xmlns:updater="clr-namespace:$rootnamespace$.Updater"
             mc:Ignorable="d" 
             d:DesignHeight="300" d:DesignWidth="300" PreviewMouseDown="UpdateNotificationControl_OnPreviewMouseDown">
    <UserControl.Resources>
        <updater:UpdaterRestartVisibilityConverter x:Key="stateVisibilityConveter"/>
    </UserControl.Resources>
    <Grid>
        <Image Margin="4" Source="../Resources/updateSettings.png" Width="16" Height="16" Visibility="{Binding State, Converter={StaticResource stateVisibilityConveter}}"/>
    </Grid>
</UserControl>
