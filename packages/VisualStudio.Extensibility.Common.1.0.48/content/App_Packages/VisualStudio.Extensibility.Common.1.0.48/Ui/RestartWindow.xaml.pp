<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<Window x:Class="$rootnamespace$.Ui.RestartWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Restart Visual Studio" Height="173" Width="470" 
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize" 
        ShowInTaskbar="False" SizeToContent="WidthAndHeight">
    <StackPanel Orientation="Vertical">
        <StackPanel Orientation="Horizontal">
            <Image Height="64" Margin="8" Width="64" Source="..\Resources\restart.png" />
            <Label Content="Restart Visual Studio" VerticalAlignment="Center" FontFamily="Georgia" FontSize="24" FontStyle="Italic" />
        </StackPanel>
        <TextBlock HorizontalAlignment="Left" Margin="16 4">
            In order to complete the installation, you should restart Visual Studio.
        </TextBlock>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
            <Button Margin="8" Padding="8 2" Content="Restart now" Name="btnOk" Click="btnOk_Click" IsDefault="True" />
            <Button Margin="8" Padding="8 2" Content="Do it later" Name="btnCancel" Click="btnCancel_Click" IsCancel="True" />
        </StackPanel>
    </StackPanel>
</Window>
