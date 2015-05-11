<!--//////////////////////////////////////////////////////////////////////////
// This file is a part of VisualStudio.Extensibility.Common NuGet package.
// You are strongly discouraged from fiddling with it.
// If you do, all hell will break loose and living will envy the dead.
//////////////////////////////////////////////////////////////////////////-->
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    <ResourceDictionary.MergedDictionaries>
        <ResourceDictionary Source="CommonStyles.xaml"/>
    </ResourceDictionary.MergedDictionaries>

    <Style x:Key="TreeViewItemFocusVisual">
        <Setter Property="Control.Template">
            <Setter.Value>
                <ControlTemplate>
                    <Rectangle />
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>

    <PathGeometry x:Key="TreeArrow">
        <PathGeometry.Figures>
            <PathFigureCollection>
                <PathFigure IsFilled="True"
                            StartPoint="0 0"
                            IsClosed="True">
                    <PathFigure.Segments>
                        <PathSegmentCollection>
                            <LineSegment Point="0 6"/>
                            <LineSegment Point="6 0"/>
                        </PathSegmentCollection>
                    </PathFigure.Segments>
                </PathFigure>
            </PathFigureCollection>
        </PathGeometry.Figures>
    </PathGeometry>

    <Style x:Key="ExpandCollapseToggleStyle"
           TargetType="{x:Type ToggleButton}">
        <Setter Property="Focusable"
                Value="False"/>
        <Setter Property="Width"
                Value="16"/>
        <Setter Property="Height"
                Value="16"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="{x:Type ToggleButton}">
                    <Border Width="16"
                            Height="16"
                            Background="Transparent"
                            Padding="5,5,5,5">
                        <Path x:Name="ExpandPath"
                              Fill="Transparent"
                              Stroke="#FF989898"
                              Data="{StaticResource TreeArrow}">
                            <Path.RenderTransform>
                                <RotateTransform Angle="135"
                                                 CenterX="3"
                                                 CenterY="3"/>
                            </Path.RenderTransform>
                        </Path>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver"
                                 Value="True">
                            <Setter TargetName="ExpandPath"
                                    Property="Stroke"
                                    Value="#FF1BBBFA"/>
                            <Setter TargetName="ExpandPath"
                                    Property="Fill"
                                    Value="Transparent"/>
                        </Trigger>

                        <Trigger Property="IsChecked"
                                 Value="True">
                            <Setter TargetName="ExpandPath"
                                    Property="RenderTransform">
                                <Setter.Value>
                                    <RotateTransform Angle="180"
                                                     CenterX="3"
                                                     CenterY="3"/>
                                </Setter.Value>
                            </Setter>
                            <Setter TargetName="ExpandPath" Property="Fill" Value="#FF595959"/>
                            <Setter TargetName="ExpandPath" Property="Stroke" Value="#FF262626"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>


    <Style x:Key="coolTreeViewItem" TargetType="{x:Type TreeViewItem}">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="HorizontalContentAlignment" Value="{Binding Path=HorizontalContentAlignment,RelativeSource={RelativeSource AncestorType={x:Type ItemsControl}}}"/>
        <Setter Property="VerticalContentAlignment" Value="{Binding Path=VerticalContentAlignment,RelativeSource={RelativeSource AncestorType={x:Type ItemsControl}}}"/>
        <Setter Property="Padding" Value="1,0,0,0"/>
        <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
        <Setter Property="FocusVisualStyle" Value="{StaticResource TreeViewItemFocusVisual}"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="{x:Type TreeViewItem}">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition MinWidth="19" Width="Auto"/>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition/>
                        </Grid.RowDefinitions>
                        <ToggleButton x:Name="Expander" Style="{StaticResource ExpandCollapseToggleStyle}"
                          IsChecked="{Binding Path=IsExpanded,RelativeSource={RelativeSource TemplatedParent}}"
                          ClickMode="Press"/>
                        <Border Name="Bd"
                    Grid.Column="1"
                    Background="{TemplateBinding Background}"
                    BorderBrush="{TemplateBinding BorderBrush}"
                    BorderThickness="1"
                    CornerRadius="2"
                    Padding="{TemplateBinding Padding}"
                    SnapsToDevicePixels="true">
                            <ContentPresenter x:Name="PART_Header"
                                ContentSource="Header"
                                HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}"
                                SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}"/>
                        </Border>
                        <ItemsPresenter x:Name="ItemsHost" Grid.Row="1" Grid.Column="1" Grid.ColumnSpan="2"/>
                    </Grid>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsExpanded" Value="false">
                            <Setter TargetName="ItemsHost" Property="Visibility" Value="Collapsed"/>
                        </Trigger>
                        <Trigger Property="HasItems" Value="false">
                            <Setter TargetName="Expander" Property="Visibility" Value="Hidden"/>
                        </Trigger>
                        <Trigger Property="IsSelected" Value="true">
                            <Setter TargetName="Bd" Property="Background" Value="{StaticResource HighlightBrush}"/>
                            <Setter TargetName="Bd" Property="BorderBrush" Value="#7DA2CE"/>
                            <Setter Property="Foreground" Value="{StaticResource ControlText}"/>
                        </Trigger>
                        <MultiTrigger>
                            <MultiTrigger.Conditions>
                                <Condition Property="IsSelected" Value="true"/>
                                <Condition Property="IsSelectionActive" Value="false"/>
                            </MultiTrigger.Conditions>
                            <Setter TargetName="Bd" Property="Background" Value="{StaticResource HighlightBrush}"/>
                            <Setter TargetName="Bd" Property="BorderBrush" Value="#7DA2CE"/>
                            <Setter Property="Foreground" Value="{StaticResource ControlText}"/>
                        </MultiTrigger>
                        <Trigger Property="IsEnabled" Value="false">
                            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.GrayTextBrushKey}}"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
        <Style.Triggers>
            <Trigger Property="VirtualizingStackPanel.IsVirtualizing" Value="true">
                <Setter Property="ItemsPanel">
                    <Setter.Value>
                        <ItemsPanelTemplate>
                            <VirtualizingStackPanel/>
                        </ItemsPanelTemplate>
                    </Setter.Value>
                </Setter>
            </Trigger>
        </Style.Triggers>
    </Style>

    <Style TargetType="TreeViewItem" BasedOn="{StaticResource coolTreeViewItem}"/>
</ResourceDictionary>