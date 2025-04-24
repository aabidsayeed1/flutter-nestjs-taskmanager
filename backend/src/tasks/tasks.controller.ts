import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { BadRequestException, Body, Controller, Delete, Get, Param, Patch, Post, Query, Req, UseGuards } from '@nestjs/common';
import { ApiBadRequestResponse, ApiBody, ApiNotFoundResponse, ApiOkResponse, ApiQuery, ApiTags } from '@nestjs/swagger';
import { CreateTaskDto } from './dtos/create-task.dto';
import { UpdateTaskDto } from './dtos/update-task.dto';
import { Task } from './entities/task.entity';
import { TasksService } from './tasks.service';
import { BatchDeleteDto } from './dtos/batch-delete-dto';

@ApiTags('Tasks')
@Controller('tasks')
@UseGuards(JwtAuthGuard)
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}
  @Get('search')
  @ApiQuery({ name: 'query', required: false, description: 'Search query for title or description' })
  @ApiQuery({
    name: 'type',
    required: false,
    enum: ['pending', 'completed', 'favorite', 'removed'],
    description: 'Type of tasks to search (e.g., pending, completed, favorite, removed)',
  })
  async searchTasks(
    @Req() req: { user: { userId: string } },
    @Query('query') query?: string,
    @Query('type') type?: 'pending' | 'completed' | 'favorite' | 'removed',
  ) {
    if (type && !['pending', 'completed', 'favorite', 'removed'].includes(type)) {
      throw new BadRequestException('Invalid task type');
    }
    return this.tasksService.searchTasks(query, type, req.user.userId);
  }
  @Post()
  @ApiBody({ type: CreateTaskDto })
  @ApiOkResponse({ type: Task, description: 'Task created successfully' })
  @ApiBadRequestResponse({ description: 'Invalid input data' })
  async create(@Body() createTaskDto: CreateTaskDto, @Req() req: { user: { userId: string } }) {
    return this.tasksService.createTask(createTaskDto, req.user.userId);
  }

  @Get()
  @ApiOkResponse({ type: [Task], description: 'List of tasks retrieved successfully' })
  async findAll(@Req() req: { user: { userId: string } }) {
    return this.tasksService.findAllTasks(req.user.userId);
  }

  @Get(':id')
  @ApiOkResponse({ type: Task, description: 'Task retrieved successfully' })
  @ApiNotFoundResponse({ description: 'Task not found' })
  async findOne(@Param('id') id: string, @Req() req: { user: { userId: string } }) {
    return this.tasksService.findOneTask(id, req.user.userId);
  }

  @Patch(':id')
  @ApiBody({ type: UpdateTaskDto })
  @ApiOkResponse({ type: Task, description: 'Task updated successfully' })
  @ApiNotFoundResponse({ description: 'Task not found' })
  async update(
    @Param('id') id: string,
    @Body() updateTaskDto: UpdateTaskDto,
    @Req() req: { user: { userId: string } },
  ) {
    return this.tasksService.updateTask(id, updateTaskDto, req.user.userId);
  }

  @Delete(':id')
  @ApiOkResponse({ description: 'Task deleted successfully' })
  @ApiNotFoundResponse({ description: 'Task not found' })
  async remove(@Param('id') id: string, @Req() req: { user: { userId: string } }) {
    await this.tasksService.removeTask(id, req.user.userId);
    return { message: 'Task deleted successfully' };
  }
    // Batch Create/Update Tasks
    @Post('batch')
    @ApiBody({
      type: [CreateTaskDto],
      description: 'Array of tasks to create or update',
    })
    @ApiOkResponse({ type: [Task], description: 'Tasks created or updated successfully' })
    @ApiBadRequestResponse({ description: 'Invalid input data' })
    async batchCreateOrUpdate(
      @Body() tasks: (CreateTaskDto | UpdateTaskDto)[],
      @Req() req: { user: { userId: string } },
    ) {
      return this.tasksService.batchCreateOrUpdateTasks(tasks, req.user.userId);
    }
    // Batch Delete Tasks
    @Post('batch-delete')    
    @ApiBody({
      type: [String],
      description: 'Array of task IDs to delete',
    })
    @ApiOkResponse({ description: 'Tasks deleted successfully' })
    @ApiBadRequestResponse({ description: 'Invalid task IDs' })
    async batchDelete(
      @Body() batchDeleteDto: BatchDeleteDto,
      @Req() req: { user: { userId: string } },
    ) {
      await this.tasksService.batchDeleteTasks(batchDeleteDto.taskIds, req.user.userId);
      return { message: 'Tasks deleted successfully' };
    }
   
}