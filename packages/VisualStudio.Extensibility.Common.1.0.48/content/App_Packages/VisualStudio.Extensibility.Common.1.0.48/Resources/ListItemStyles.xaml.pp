<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ResourceDictionary.MergedDictionaries>
        <ResourceDictionary Source="CommonStyles.xaml"/>
    </ResourceDictionary.MergedDictionaries>
    
    <Style x:Key="coolTreeViewItem" TargetType="TreeViewItem">
        <Setter Property="BorderThickness" Value="1"/>
        <Style.Triggers>
            <Trigger Property="IsSelected" Value="True">
                <Setter Property="Background" Value="{StaticResource HighlightBrush}"/>
                <Setter Property="BorderBrush" Value="#7DA2CE"/>
                <Setter Property="Foreground" Value="{StaticResource ControlText}"/>
            </Trigger>
        </Style.Triggers>
        <Style.Resources>
            <Style TargetType="Border">
                <Setter Property="CornerRadius" Value="2"/>
            </Style>
        </Style.Resources>
    </Style>

    <Style TargetType="ListBoxItem">
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="ListBoxItem">
                    <Border BorderThickness="1" CornerRadius="2" x:Name="border">
                        <ContentPresenter Content="{TemplateBinding Content}" ContentTemplate="{TemplateBinding ContentTemplate}"/>
                    </Border>
                    
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsSelected" Value="True">
                            <Setter TargetName="border" Property="Background" Value="{StaticResource ControlBrush}"/>
                            <Setter TargetName="border" Property="BorderBrush" Value="#7DA2CE"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>

    <Style TargetType="ListViewItem">
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="ListViewItem">
                    <Border BorderThickness="1" CornerRadius="2" x:Name="border">
                        <GridViewRowPresenter VerticalAlignment="{TemplateBinding VerticalContentAlignment}" />
                    </Border>

                    <ControlTemplate.Triggers>
                        <Trigger Property="IsSelected" Value="True">
                            <Setter TargetName="border" Property="Background" Value="{StaticResource ControlBrush}"/>
                            <Setter TargetName="border" Property="BorderBrush" Value="#7DA2CE"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>

    <Style TargetType="TreeViewItem" BasedOn="{StaticResource coolTreeViewItem}"/>
</ResourceDictionary>