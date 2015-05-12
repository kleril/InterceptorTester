<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                    xmlns:System="clr-namespace:System;assembly=mscorlib"
                    xmlns:Ui="clr-namespace:$rootnamespace$.Ui">
    
    <Style TargetType="{x:Type Ui:SkinnedWindow}">
        <Setter Property="WindowStyle" Value="None"/>
        <Setter Property="AllowsTransparency" Value="True"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="{x:Type Ui:SkinnedWindow}">
                    <Border CornerRadius="5" BorderThickness="3">
                        <Border.BorderBrush>
                            <SolidColorBrush Opacity="0.35" Color="#c6daec"/>
                        </Border.BorderBrush>
                        <Border CornerRadius="2" Background="#f8fcff" BorderBrush="#d5d8db" BorderThickness="1">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                </Grid.RowDefinitions>

                                <DockPanel Name="title" Grid.Row="0">
                                    <Label x:Name="btnCloseWindow" Cursor="Arrow" DockPanel.Dock="Right" VerticalAlignment="Top" FontFamily="Calibri" Foreground="#577b99" FontSize="24" FontWeight="UltraBlack" Content="×" Margin="0 -6 4 0" >
                                        <Label.Style>
                                            <Style TargetType="Label">
                                                <Style.Triggers>
                                                    <Trigger Property="IsMouseOver" Value="True">
                                                        <Setter Property="Opacity" Value="1"/>
                                                    </Trigger>
                                                    <Trigger Property="IsMouseOver" Value="False">
                                                        <Setter Property="Opacity" Value="0.45"/>
                                                    </Trigger>
                                                </Style.Triggers>
                                            </Style>
                                        </Label.Style>
                                    </Label>
                                    <TextBlock DockPanel.Dock="Left" VerticalAlignment="Center" Margin="8" Text="{TemplateBinding Title}" FontFamily="Calibri" Foreground="#577b99" FontSize="14" TextWrapping="Wrap" />
                                </DockPanel>
                                <ContentPresenter Grid.Row="1" Content="{TemplateBinding Content}"/>
                            </Grid>
                        </Border>
                    </Border>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</ResourceDictionary>