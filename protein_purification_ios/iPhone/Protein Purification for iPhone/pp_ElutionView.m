//
//  pp_ElutionView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 06/08/2012.
//
//

#import "pp_ElutionView.h"

@implementation pp_ElutionView {

float xscale;
float yscale;
float xOffset;
float yOffset;
float labelYOffset;
float labelXOffset;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        xOffset = 60.0;
        yOffset = 40.0;
        labelXOffset = 0.0;
        labelXOffset = 0.0;
    }
    return self;
}

- (void) shadeSelection:(NSMutableArray*) coords no: (int) no
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextClipToRect(con, CGRectMake(xOffset*xscale,yOffset*yscale, 500.0*xscale, 320.0*yscale));
    CGContextSetStrokeColorWithColor(con, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(con, [UIColor colorWithRed:0.266 green:0.266 blue:0.266 alpha:0.5].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(([[coords objectAtIndex:0] floatValue]+xOffset)*xscale,([[coords objectAtIndex:1] floatValue]+yOffset)*yscale)];
    for (int i=2; i<no; i+=2)
     [path addLineToPoint:CGPointMake(([[coords objectAtIndex:i] floatValue]+xOffset)*xscale,([[coords objectAtIndex:i+1] floatValue]+yOffset)*yscale)];
    [path closePath];
    [path fill];
    [path stroke];
    CGContextRestoreGState(con);

    
}


- (void) create_line: (float) x1 y1:(float) y1 x2: (float) x2 y2: (float) y2 colour: (UIColor*) colour
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextMoveToPoint(con, (x1+xOffset)*xscale, (y1+yOffset)*yscale);
    CGContextAddLineToPoint(con, (x2+xOffset)*xscale, (y2+yOffset)*yscale);
    CGContextSetStrokeColorWithColor(con, colour.CGColor);
    CGContextSetLineWidth(con, 1.0);
    CGContextStrokePath(con);
    CGContextRestoreGState(con);
    
}


- (void) create_polyline: (NSMutableArray*) coords colour: (UIColor*) colour no: (int) no
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextClipToRect(con, CGRectMake(xOffset*xscale,yOffset*yscale, 500.0*xscale, 320.0*yscale));
    CGContextMoveToPoint(con, ([[coords objectAtIndex:0] floatValue]+xOffset)*xscale, ([[coords objectAtIndex:1] floatValue]+yOffset)*yscale);
    for (int i=2; i<no; i+=2)
        CGContextAddLineToPoint(con, ([[coords objectAtIndex:i] floatValue]+xOffset)*xscale, ([[coords objectAtIndex:i+1] floatValue]+yOffset)*yscale);
    CGContextSetStrokeColorWithColor(con, colour.CGColor);
    CGContextSetLineWidth(con, 1.0);
    CGContextStrokePath(con);
    CGContextRestoreGState(con);
    
}

/*
// Get points from Bezier Curve
void getPointsFromBezier(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // Retrieve the path element type and its points
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // Add the points if they're available (per type)
    if (type != kCGPathElementCloseSubpath)
    {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) &&
            (type != kCGPathElementMoveToPoint))
            [bezierPoints addObject:VALUE(1)];
    }
    if (type == kCGPathElementAddCurveToPoint)
        [bezierPoints addObject:VALUE(2)];
}

NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(bpath.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}

- (UIBezierPath*)smoothedPathWithGranularity:(UIBezierPath*)path granularity:(NSInteger)granularity;
{
    NSMutableArray *points = [pointsFromBezierPath(path) mutableCopy];
    
    if (points.count < 4) return [self copy];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath *smoothedPath = [path copy];
    [smoothedPath removeAllPoints];
    
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++)
    {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}



- (void) create_smoothed_polyline: (NSMutableArray*) coords colour: (UIColor*) colour no: (int) no
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextClipToRect(con, CGRectMake(xOffset*xscale,yOffset*yscale, 500.0*xscale, 320.0*yscale));
    CGContextSetStrokeColorWithColor(con, colour.CGColor);
    CGContextSetLineWidth(con, 1.0);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    
    [path moveToPoint:CGPointMake(([[coords objectAtIndex:0] floatValue]+xOffset)*xscale, ([[coords objectAtIndex:1] floatValue]+yOffset)*yscale)];
    
    for (int i=2; i<no; i+=2)
        [path addLineToPoint:CGPointMake(([[coords objectAtIndex:i] floatValue]+xOffset)*xscale, ([[coords objectAtIndex:i+1] floatValue]+yOffset)*yscale)];
    
    UIBezierPath* smoothed = [self smoothedPathWithGranularity:path granularity:(NSInteger)5];
    
    [smoothed stroke];
    CGContextRestoreGState(con);
    
}
*/
- (void) create_text_in_box:(NSString*) text rect: (CGRect) rect size:(float) size colour: (UIColor*) colour angle: (float) angle italic: (bool) italic alignment: (int) alignment
{
    
    float x = 0.0;
    float y = 0.0;
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
    // Set text rotation
    CGContextSetTextMatrix (con, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.0, -1.0 ), angle));

    // CGContextShowTextAtPoint only works with C strings encoded with MacOSRoman, not UTF8 or UTF16
    // so the text has to be transcoded.
    NSData *strData = [text dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:YES];
    char string[[strData length] + 1];
    memcpy(string, [strData bytes], [strData length] + 1);
    string[[strData length]] = '\0';
    
    // set the font
    UIFont* font;
    if (italic)
        font = [UIFont fontWithName:@"Helvetica-Oblique" size:size];
    else
        font = [UIFont fontWithName:@"Helvetica" size:size];
    
    const char* fontName = [font.fontName UTF8String];
    
    CGContextSelectFont( con, fontName, size, kCGEncodingMacRoman);
    
    CGContextSetStrokeColorWithColor(con, colour.CGColor);
    CGContextSetFillColorWithColor(con, colour.CGColor);
    
    // convert the sender rectangle to real coordinates
    CGRect ourRect = CGRectMake((rect.origin.x+xOffset)*xscale,(rect.origin.y+yOffset)*yscale, rect.size.width*xscale, rect.size.height*yscale );

    // work out the size of the rectangle bounding the text
    CGSize expectedSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:size] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];


    if (angle==0)
    {
        if (alignment==centre) // centered
        {
            x = ourRect.origin.x + ((ourRect.size.width-expectedSize.width)/2.0);
            y = ourRect.origin.y + expectedSize.height/yscale/3.5;
        }
        else if (alignment==right) // right-aligned
        {
            x = ourRect.origin.x + (ourRect.size.width-expectedSize.width);
            y = ourRect.origin.y + expectedSize.height/yscale/7.0;
        }
        else
        {
            x = ourRect.origin.x; // default is left-aligned
            y = ourRect.origin.y + expectedSize.height/yscale/7.0;
        }    }
    else if (angle > 0.0) // assuming 90 degree rotation anticlockwise
    {
        y = ourRect.origin.y + ourRect.size.height - ((ourRect.size.height-expectedSize.width)/2.0);
        x = ourRect.origin.x + ourRect.size.width;
    }
    else // assuming 90 degree rotation clockwise
    {
        y = ourRect.origin.y + ((ourRect.size.height-expectedSize.width)/2.0);
        x = ourRect.origin.x;
    }
    
    CGContextShowTextAtPoint(con, x, y, string, strlen(string));
    
    CGContextRestoreGState(con);
}

- (void) drawFrame:(bool) activity gradient: (bool) gradient
{
    
    // Add the title
    
    if (!app.splitViewController.isShowingMaster)
    {
        NSString* title = [NSString stringWithFormat:NSLocalizedString(@"%@ on %@",@""),app.separation.sepString,app.separation.mediumString];
        [self create_text_in_box:title
                        rect:CGRectMake(0.0, -35.0, 500.0, 0.0)
                        size:15.0
                      colour:[UIColor blackColor]
                       angle:0
                      italic:YES
                   alignment:centre];
    }
    // Draw the frame
    [self create_line:0.0 y1:324.0 x2:499.0 y2:324.0 colour:[UIColor darkGrayColor]];
    [self create_line:499.0 y1:324.0 x2:499.0 y2:0.0 colour:[UIColor darkGrayColor]];
    [self create_line:499.0 y1:0.0 x2:0.0 y2:0.0 colour:[UIColor whiteColor]];
    [self create_line:0.0 y1:0.0 x2:0.0 y2:324.0 colour:[UIColor whiteColor]];
    
    // Add the fractions position marks
    for(int i=1; i<13; i++)
    {
        [self create_line: -4.0+i*40.0 y1:324.0 x2:-4.0+i*40.0 y2:319.0 colour:[UIColor whiteColor]];
        [self create_line: -3.0+i*40.0 y1:324.0 x2:-3.0+i*40.0 y2:319.0 colour:[UIColor darkGrayColor]];
        [self create_line: -24.0+i*40.0 y1:324.0 x2:-24.0+i*40.0 y2:322.0 colour:[UIColor whiteColor]];
        [self create_line: -23.0+i*40.0 y1:324.0 x2:-23.0+i*40.0 y2:322.0 colour:[UIColor darkGrayColor]];
    }
    
    // Draw the Absorbance axis tick marks
    
    [self create_line: 1.0 y1:316.0 x2:5.0 y2:316.0 colour:[UIColor darkGrayColor]];
    [self create_line: 1.0 y1:162.0 x2:5.0 y2:162.0 colour:[UIColor darkGrayColor]];
    [self create_line: 1.0 y1:8.0 x2:5.0 y2:8.0 colour:[UIColor darkGrayColor]];
    
    // Draw the Absorbance title
    
    if (!app.splitViewController.isShowingMaster)
    {
        [self create_text_in_box:NSLocalizedString(@"Absorbance at 280 nm",@"")
                        rect:CGRectMake(-53.0,0.0,8.0,325.0)
                        size:12.0
                      colour:[UIColor blueColor]
                       angle:M_PI/2.0
                      italic:NO
                   alignment:centre];
    
        // Add the Absorbance labels
    
        [self create_text_in_box:[NSString stringWithFormat:@"%.1f",app.commands.scale*4.0]
                        rect:CGRectMake(-12.0,8.0,8.0,0.0)
                        size:12.0
                      colour:[UIColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
        [self create_text_in_box:[NSString stringWithFormat:@"%.1f",app.commands.scale*2.0]
                        rect:CGRectMake(-12.0,162.0,8.0,0.0)
                        size:12.0
                      colour:[UIColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
        [self create_text_in_box:[NSString stringWithFormat:@"%d",0]
                        rect:CGRectMake(-12.0,316.0,8.0,0.0)
                        size:12.0
                      colour:[UIColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    }
    // Add the fraction numbers
    for(int i=1; i<13; i++)
    {
        if ((i % 2 == 1) && app.splitViewController.isShowingMaster) continue;
        float xpos = labelXOffset+i*40.0;
        [self create_text_in_box:[NSString stringWithFormat:@"%d",i*10]
                            rect:CGRectMake(xpos,330.0,40.0,0.0)
                            size:12.0
                          colour:[UIColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:centre];
    }
    
    // Add the fraction label
    [self create_text_in_box:NSLocalizedString(@"Fraction number",@"")
                        rect:CGRectMake(0.0, 360.0, 500.0, 0.0)
                        size:12.0
                      colour:[UIColor blackColor]
                       angle:0
                      italic:NO
                   alignment:centre];
    
    if (activity && !app.splitViewController.isShowingMaster)
    {
        // Add the Enzyme title
        [self create_text_in_box:NSLocalizedString(@"Enzyme activity (Units/fraction)",@"")
                            rect:CGRectMake(540.0,10.0,0.0,310.0)
                            size:12.0
                          colour:[UIColor redColor]
                           angle:-M_PI/2.0
                          italic:NO
                       alignment:centre];
        
        // Add the Enzyme labels
        [self create_text_in_box:[NSString stringWithFormat:@"%d",0]
                            rect:CGRectMake(505.0,316.0,8.0,0.0)
                            size:12.0
                          colour:[UIColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:left];
        [self create_text_in_box:[NSString stringWithFormat:@"%d",(int)round([app.proteinData GetCurrentActivityOfProtein:app.proteinData.enzyme]*800.0*app.commands.scale/3.0)]
                            rect:CGRectMake(505.0,8.0,8.0,0.0)
                            size:12.0
                          colour:[UIColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:left];
    }
     
    if (gradient)
    {
        
        if (app.commands.startGrad > app.commands.endGrad)
        {
            [self create_line:124.0 y1:8.0 x2:499.0 y2:316.0 colour:[UIColor magentaColor]];
            [self create_line:0.0 y1:8.0 x2:124.0 y2:8.0 colour:[UIColor magentaColor]];
        }
        else
        {
            [self create_line:124.0 y1:316.0 x2:499.0 y2:8.0 colour:[UIColor magentaColor]];
            [self create_line:0.0 y1:316.0 x2:124.0 y2:316.0 colour:[UIColor magentaColor]];
        }
        
        if (activity==NO)
        {
            
            NSString* startString;
            NSString* endString;
            
            if (app.commands.startGrad < 0.05) startString=@"0";
            else startString = [NSString stringWithFormat:@"%.1f",app.commands.startGrad];
            
            if (app.commands.endGrad < 0.05) endString=@"0";
            else endString = [NSString stringWithFormat:@"%.1f",app.commands.endGrad];
            
            if (!app.splitViewController.isShowingMaster)
            {
                if (app.commands.gradientIsSalt)
                {
                
                    // Add the gradient title
                    [self create_text_in_box:NSLocalizedString(@"Salt concentration (molar)",@"")
                                    rect:CGRectMake(540.0,10.0,0.0,310.0)
                                    size:12.0
                                  colour:[UIColor magentaColor]
                                   angle:-M_PI/2.0
                                  italic:NO
                               alignment:centre];
                    if (app.commands.endGrad > app.commands.startGrad)
                    {
                        // Add the gradient labels
                        [self create_text_in_box:startString
                                        rect:CGRectMake(505.0,316.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                        [self create_text_in_box:endString
                                        rect:CGRectMake(505.0,8.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    }
                    else
                    {
                        [self create_text_in_box:endString
                                        rect:CGRectMake(505.0,316.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    
                        [self create_text_in_box:startString
                                        rect:CGRectMake(505.0,8.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    }
                }
                else
                {
                
                    // Add the gradient title
                    [self create_text_in_box:NSLocalizedString(@"pH",@"")
                                    rect:CGRectMake(540.0,160.0,10.0,8.0)
                                    size:12.0
                                  colour:[UIColor magentaColor]
                                   angle:0
                                  italic:NO
                               alignment:left];
                    if (app.commands.endGrad > app.commands.startGrad)
                    {
                        // Add the gradient labels
                        [self create_text_in_box:startString
                                        rect:CGRectMake(505.0,316.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                        
                        [self create_text_in_box:endString
                                        rect:CGRectMake(505.0,8.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    }
                    else
                    {
                        [self create_text_in_box:endString
                                        rect:CGRectMake(505.0,316.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                        [self create_text_in_box:startString
                                        rect:CGRectMake(505.0,8.0,8.0,0.0)
                                        size:12.0
                                      colour:[UIColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    }
                }
            }
            
        }
    }
    
    if ((app.commands.sepType == Affinity) && !app.splitViewController.isShowingMaster)  // Footer for Affinity chromatography
    {
        NSString* footer = [NSString stringWithFormat:NSLocalizedString(@"(Elution buffer emerges at fraction 40)",@""),app.separation.sepString,app.separation.mediumString];
        [self create_text_in_box:footer
                            rect:CGRectMake(0.0, 385.0, 500.0, 0.0)
                            size:12.0
                          colour:[UIColor blackColor]
                           angle:0
                          italic:NO
                       alignment:centre];
    }
}

- (void) drawElution:(bool) activity gradient: (bool) gradient pooled: (bool) pool
{
    
    [self drawFrame: activity gradient: gradient];
    
    NSMutableArray* blue_coords= [[NSMutableArray alloc]init];
    
    float x = 1.0;
    float y = 316.0 - [app.separation GetPlotElement:1 protein:0]/app.commands.scale;
    
    [blue_coords addObject:[NSNumber numberWithFloat:x]];
    [blue_coords addObject:[NSNumber numberWithFloat:y]];
    
    int pos = 2;
    for (int i=2; i< 251; i++)
    {
        x = 2.0*((float)i - 1.0);
        y = 316.0 - [app.separation GetPlotElement:i protein:0]/app.commands.scale;

        [blue_coords addObject:[NSNumber numberWithFloat:x]];
        [blue_coords addObject:[NSNumber numberWithFloat:y]];
        pos+=2;
    }
    [self create_polyline:blue_coords colour: [UIColor blueColor] no: pos-1];
    
 
    if (activity)
    {
        
        NSMutableArray* red_coords= [[NSMutableArray alloc]init];
        
        x = 1.0;
        
        float origin = 315.0;
        
        y = origin;
        
        pos = 0;

        for (int i=1; i<251; i++)
        {
            
            float oldx = x;
            float oldy = y;
            
            x = 2.0*((float)i - 1.0);
            y = (316.0 - [app.separation GetPlotElement:i protein:app.proteinData.enzyme]*4.0*(float)[app.proteinData GetCurrentActivityOfProtein:app.proteinData.enzyme]/app.commands.scale);
            
            if ((oldy==origin) && (y < origin)) {
                
                [red_coords addObject:[NSNumber numberWithFloat:oldx]];
                [red_coords addObject:[NSNumber numberWithFloat:oldy]];
                pos+=2;
            }
            if ((y < origin) || (oldy < origin)) {
                
                [red_coords addObject:[NSNumber numberWithFloat:x]];
                [red_coords addObject:[NSNumber numberWithFloat:y]];
                pos+=2;
            }
            
        }
        
        if (pos > 0 )
        {
            [self create_polyline:red_coords colour:[UIColor redColor] no:pos-1];
        }
    }

    if (pool) {
        
        NSMutableArray* black_coords = [[NSMutableArray alloc]init];
        
        int start_pool = 2 * app.commands.startOfPool - 1;
        int end_pool = 2 * app.commands.endOfPool;
        
        float origin = 316.0;
        
        x = 2.0*((float)start_pool - 1.0);
        y = origin;
        
        pos = 0;
        
        [black_coords addObject:[NSNumber numberWithFloat:x]];
        [black_coords addObject:[NSNumber numberWithFloat:y]];
        pos+=2;
        
        for (int i=start_pool; i<= end_pool; i++) {
            x = 2.0*((float)i - 1.0);
            y = (316.0 - [app.separation GetPlotElement:i protein:0]/app.commands.scale);
            
            [black_coords addObject:[NSNumber numberWithFloat:x]];
            [black_coords addObject:[NSNumber numberWithFloat:y]];
            pos+=2;
        }
        [black_coords addObject:[NSNumber numberWithFloat:x]];
        [black_coords addObject:[NSNumber numberWithFloat:origin]];
        pos+=2;
        
        x = 2.0*((float)start_pool - 1.0);
        y = origin;
        
        [black_coords addObject:[NSNumber numberWithFloat:x]];
        [black_coords addObject:[NSNumber numberWithFloat:y]];
        pos++;
        
        [self shadeSelection:black_coords no:pos];
    }

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
        
    float xsize = self.frame.size.width;
    float ysize = self.frame.size.height;
    
    // scale in landscape
    xscale = xsize/640.0;
    yscale = ysize/480.0;
    xOffset = 65.0;
    yOffset = 60.0;
    labelYOffset = 17.0;
    labelXOffset = -23.0;
            
    self.autoresizingMask = UIViewAutoresizingNone;
    
    [self drawElution:app.commands.assayed gradient:app.commands.hasGradient  pooled:app.commands.pooled];
}


@end
